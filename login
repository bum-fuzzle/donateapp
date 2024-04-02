package com.example.donorhub.common.login;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.example.donorhub.MemoryData;
import com.example.donorhub.R;
import com.example.donorhub.common.WelcomeScreen;
import com.example.donorhub.common.signup.Signup;
import com.example.donorhub.user.UserDashboard;
import com.example.donorhub.user.UserProfile;
import com.google.android.material.textfield.TextInputLayout;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.Query;
import com.google.firebase.database.ValueEventListener;

public class Login extends AppCompatActivity {

    TextInputLayout textInputLayoutPhone, textInputLayoutPwd;

     ProgressBar progressBarLogin;
     Button logInBtn, createAccount;

     FirebaseAuth authProfile;



    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R .layout.activity_login);

        textInputLayoutPhone = findViewById(R.id.log_in_phone);
        textInputLayoutPwd = findViewById(R.id.lig_in_password);
        progressBarLogin = findViewById(R.id.log_in_progressbar);





        logInBtn = findViewById(R.id.log_in_btn);
        createAccount = findViewById(R.id.create_account);

        createAccount.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Login.this, Signup.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                startActivity(intent);
                finish();
            }
        });

        logInBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String phoneNumber = textInputLayoutPhone.getEditText().getText().toString();
                String passWord = textInputLayoutPwd.getEditText().getText().toString();
                if (phoneNumber.isEmpty() || passWord.isEmpty()){
                    Toast.makeText(Login.this, "Please Enter your mobile or password", Toast.LENGTH_SHORT).show();
                }
                progressBarLogin.setVisibility(View.VISIBLE);
                Query checkData = FirebaseDatabase.getInstance().getReference("Users").orderByChild("phoneNo").equalTo(phoneNumber);
                    checkData.addListenerForSingleValueEvent(new ValueEventListener() {
                        @Override
                        public void onDataChange(@NonNull DataSnapshot snapshot) {
                            if (snapshot.exists()){
                                textInputLayoutPhone.setError(null);
                                textInputLayoutPhone.setErrorEnabled(false);

                                String getPassword = snapshot.child(phoneNumber).child("password").getValue(String.class);
                                if (getPassword.equals(passWord)) {
                                    textInputLayoutPwd.setError(null);
                                    textInputLayoutPwd.setErrorEnabled(false);
                                    Toast.makeText(Login.this, "login Successful", Toast.LENGTH_SHORT).show();
                                    String fullName = snapshot.child(phoneNumber).child("fullName").getValue(String.class);
                                    String userName = snapshot.child(phoneNumber).child("userName").getValue(String.class);
                                    String user = snapshot.child(phoneNumber).child("_user").getValue(String.class);
                                    String email = snapshot.child(phoneNumber).child("email").getValue(String.class);


                                    Intent intent = new Intent(Login.this, UserDashboard.class);
                                    intent.putExtra("fullName", fullName);
                                    intent.putExtra("userName", userName);
                                    intent.putExtra("user", user);
                                    intent.putExtra("phoneNo", phoneNumber);
                                    intent.putExtra("email", email);
                                    intent.putExtra("password", getPassword);
                                    startActivity(intent);
                                    finish();
                                }
                                else {
                                    progressBarLogin.setVisibility(View.GONE);
                                    Toast.makeText(Login.this, "Password does not match", Toast.LENGTH_SHORT).show();
                                }
                            }else{
                                progressBarLogin.setVisibility(View.GONE);

                            }
                        }

                        @Override
                        public void onCancelled(@NonNull DatabaseError error) {
                            progressBarLogin.setVisibility(View.GONE);
                            Toast.makeText(Login.this, "Error", Toast.LENGTH_SHORT).show();
                        }
                    });
            }
        });

    }


    public void backBtn(View view){
        Intent intent = new Intent(getApplicationContext(), WelcomeScreen.class);
        startActivity(intent);
        finish();
    }


}
