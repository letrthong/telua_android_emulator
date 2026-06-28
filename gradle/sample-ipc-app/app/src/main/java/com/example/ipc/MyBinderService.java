package com.example.ipc;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.RemoteException;
import android.util.Log;

public class MyBinderService extends Service {
    private static final String TAG = "MyBinderService";

    // Thực thi các phương thức được định nghĩa trong file AIDL
    private final IMyAidlInterface.Stub binder = new IMyAidlInterface.Stub() {
        @Override
        public String greet(String name) throws RemoteException {
            Log.d(TAG, "greet() được gọi từ Client: " + name);
            return "Xin chào " + name + " từ AIDL Service!";
        }

        @Override
        public int add(int num1, int num2) throws RemoteException {
            Log.d(TAG, "add() được gọi: " + num1 + " + " + num2);
            return num1 + num2;
        }
    };

    @Override
    public IBinder onBind(Intent intent) {
        Log.d(TAG, "Client đã bind vào Service.");
        return binder;
    }
}
