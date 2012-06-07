public void SOMADLTracking(Context context) {
    if (context == null) {
        Log.e("SOMA", "Received uninitialized context!");
        return;
    }

    String IMEI = null;
    String ANROIDID = null;
    String ODIN = null;

    try {
        TelephonyManager telephonyManager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
        if (telephonyManager != null) {
            IMEI = telephonyManager.getDeviceId();
            if (IMEI != null)
                IMEI = IMEI.toLowerCase();
        }
        if (IMEI == null || IMEI.length() == 0) {
            Log.v(TAG, "No IMEI/MEID found");
        }
        ANROIDID = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
        if (ANROIDID == null || ANROIDID.length() == 0) {
            Log.v(TAG, "No Androi ID found");
        }

    } catch (Exception e) {
        // do nothing
    }

    if (IMEI == null)
        IMEI = "0000000000000000";

    // make connection to ping server for the DL
    HttpURLConnection connection = null;
    InputStream inB = null;
    try {
        String p = context.getPackageName();
        PackageInfo pi = context.getPackageManager().getPackageInfo(p, 0);
        String an = pi.packageName; String av = pi.versionName;
        SharedPreferences settings = context.getSharedPreferences(an, 0);
        boolean firststart = settings.getBoolean("firstping", true);
        StringBuffer aurl = new StringBuffer("http://soma.smaato.net/oapi/dl.jsp");
        aurl.append("?app=").append(URLEncoder.encode( an, "UTF-8" ));
        aurl.append("&ownid=").append(IMEI);
        aurl.append("&version=").append(URLEncoder.encode(av,"UTF-8"));
        aurl.append("&firststart=").append(firststart);
        String theping = aurl.toString();
        Log.v("SOMA","Download tracking ping: "+theping);
        URL url = new URL(theping);
        connection = (HttpURLConnection)url.openConnection();
        connection.setRequestMethod("GET");
        connection.setConnectTimeout(10000);
        connection.connect();
        inB = connection.getInputStream();
        if(connection.getResponseCode() == 200) {
            if(firststart) {
                firststart = false;
                SharedPreferences.Editor editor = settings.edit();
                editor.putBoolean("firstping", firststart);
                editor.commit();
            }
            Log.v("SOMA","Success");
        }
    } catch (Exception ee) {
        Log.e("SOMA", ee.getMessage());
    } finally {
        if (inB != null) {
            try {
                inB.close();
            } catch (IOException e) {
                // Ignore and continue.
            }
        }
        if (connection != null) {
            //close the connection
            connection.disconnect();
        }
    }
}