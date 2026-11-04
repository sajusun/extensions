# SnapDisplay - Virtual Second Monitor (Extended Desktop)

Turn any Android phone or tablet into a genuine secondary monitor for Windows!

---

## 🚀 How to Enable (1-Click)

1. Open this folder:
   ```
   c:\Users\Dell\projects\extensions\snapdisplay\companion\
   ```
2. Right-click **`enable-second-monitor.bat`** and choose **"Run as administrator"** (or double-click it and click **Yes** on the Windows UAC prompt).
3. The script will:
   - Configure the virtual 1080p 60Hz display surface
   - Trust driver certificates in Windows Certificate Store
   - Install the Virtual Display Driver (IddCx) and register the `Root\MttVDD` hardware node
   - Open **Windows Display Settings**
4. In Windows Display Settings, you will see two displays:
   ```
   [ 1 ]       [ 2 ]
   ```
5. Ensure **"Multiple displays"** is set to **"Extend these displays"**.
6. Return to **SnapDisplay** in your browser:
   - Click **`🖥️ Virtual Second Monitor`**
   - Click **`🚀 Stream Extended Display (Screen 2) to Phone`**
   - In the browser picker, select **Screen 2** (the virtual monitor).
7. Done! Drag any window (Chrome, VS Code, File Explorer) past the right edge of your laptop monitor—it will glide right onto your phone!

---

## 🛑 How to Disable / Remove

Whenever you are done:
- Double-click **`disable-second-monitor.bat`** (click Yes on UAC).
- Windows will immediately remove `Display 2` and return to single-screen mode.
