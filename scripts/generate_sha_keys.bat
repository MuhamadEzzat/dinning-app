@echo off
echo Generating SHA-1 and SHA-256 keys for Firebase...
echo.

REM Navigate to android directory
cd android

REM Generate debug keystore SHA-1 and SHA-256
echo Debug Keystore SHA-1 and SHA-256:
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

echo.
echo ========================================
echo.

REM Generate release keystore SHA-1 and SHA-256 (if exists)
if exist "app\release-key.keystore" (
    echo Release Keystore SHA-1 and SHA-256:
    keytool -list -v -keystore app\release-key.keystore -alias release-key
) else (
    echo Release keystore not found. Create one if needed for production.
)

echo.
echo ========================================
echo.
echo Copy the SHA-1 and SHA-256 fingerprints above to your Firebase project.
echo Go to Project Settings > Your Apps > Android App > SHA certificate fingerprints
echo.

pause









