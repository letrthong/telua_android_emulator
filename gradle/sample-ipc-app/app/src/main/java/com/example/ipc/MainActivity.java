package com.example.ipc;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = "MainActivity";
    private IMyAidlInterface mAidlService = null;
    private boolean mIsBound = false;

    private TextView txtResult;
    private Button btnCallAidl;

    private final ServiceConnection mConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName className, IBinder service) {
            // Chuyển đổi binder nhận được thành Java Interface của AIDL
            mAidlService = IMyAidlInterface.Stub.asInterface(service);
            mIsBound = true;
            Toast.makeText(MainActivity.this, "Đã kết nối Service AIDL!", Toast.LENGTH_SHORT).show();
            btnCallAidl.setEnabled(true);
            txtResult.setText("Đã kết nối! Nhấn nút để gọi hàm IPC.");
        }

        @Override
        public void onServiceDisconnected(ComponentName className) {
            mAidlService = null;
            mIsBound = false;
            Toast.makeText(MainActivity.this, "Đã ngắt kết nối Service!", Toast.LENGTH_SHORT).show();
            btnCallAidl.setEnabled(false);
            txtResult.setText("Đã ngắt kết nối Service.");
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Tạo layout đơn giản bằng code để không cần file XML layout phức tạp
        android.widget.LinearLayout layout = new android.widget.LinearLayout(this);
        layout.setOrientation(android.widget.LinearLayout.VERTICAL);
        layout.setPadding(60, 60, 60, 60);

        TextView title = new TextView(this);
        title.setText("AIDL IPC Demonstration");
        title.setTextSize(22);
        title.setPadding(0, 0, 0, 40);
        layout.addView(title);

        btnCallAidl = new Button(this);
        btnCallAidl.setText("Gọi các hàm AIDL");
        btnCallAidl.setEnabled(false);
        layout.addView(btnCallAidl);

        txtResult = new TextView(this);
        txtResult.setText("Đang kết nối tới Service...");
        txtResult.setTextSize(16);
        txtResult.setPadding(0, 40, 0, 0);
        layout.addView(txtResult);

        setContentView(layout);

        btnCallAidl.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mIsBound && mAidlService != null) {
                    try {
                        // Gọi hàm IPC qua AIDL
                        String greeting = mAidlService.greet("Android Client");
                        int sum = mAidlService.add(123, 456);
                        
                        txtResult.setText("Kết quả nhận được từ Service:\n\n" 
                                + "1. greet(\"Android Client\"):\n   👉 \"" + greeting + "\"\n\n"
                                + "2. add(123, 456):\n   👉 " + sum);
                    } catch (RemoteException e) {
                        Log.e(TAG, "Lỗi khi gọi hàm AIDL IPC", e);
                        txtResult.setText("Lỗi RemoteException!");
                    }
                }
            }
        });

        // Liên kết tới service
        Intent intent = new Intent(this, MyBinderService.class);
        bindService(intent, mConnection, Context.BIND_AUTO_CREATE);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (mIsBound) {
            unbindService(mConnection);
            mIsBound = false;
        }
    }
}
