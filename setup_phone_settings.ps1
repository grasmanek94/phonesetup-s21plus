Set-Location -Path "$PSScriptRoot"
$device_name = "GZXS21P"

function ADB-Change-Setting {
    param(
        $Namespace,
        $Key,
        $Value
    )
    
    adb shell "su -c settings put $Namespace \""$Key\"" \""$Value\"""
}

function ADB-Change-Service {
    param(
        $Key,
        $Value
    )
    
    adb shell "su -c svc \""$Key\"" \""$Value\"""
}

function ADB-Change-Settings-List {
    param(
        $Namespace,
        $Array
    )
    
    $Array | ForEach-Object{
        ADB-Change-Setting -Namespace $Namespace -Key $_ -Value $Array[$_]
    }
}

function ADB-Change-Settings {
    $global = @{
        uwb_enabled=0 # don't use uwb so disable
        sem_wifi_network_rating_scorer_enabled=0 # display wifi ratings off (contacts samsung)
        sem_wifi_switch_to_better_wifi_enabled=0 # switch to better wifi automatically when screen off off
        network_avoid_bad_wifi=1 # enable mobile data on bad wifi
        navigation_bar_gesture_while_hidden=0 # use buttons
        navigationbar_key_order=1 # back button on left
        animator_duration_scale=0.25 # snappier experience
        transition_animation_scale=0.25 # snappier experience
        window_animation_scale=0.25 # snappier experience
        adb_allowed_connection_time=0 # disable authorization timeout 
        art_verifier_verify_debuggable=0 # disable verify bytecode of debuggable apps
        verifier_verify_adb_installs=0 # disable verify apps over USB
        function_key_config_longpress_type=1 # use power menu instead of bixby
        power_button_long_press=1 # use power menu instead of bixby
        device_name=$device_name # set device name here
        data_roaming=1 # enable data roaming
        set_network_mode_by_rat_change=0 # enable data roaming
        preferred_network_mode1=9 # turn off 5g to save battery
        preferred_network_mode=9,26 # turn off 5g to save battery
        turnOff_5g_option_by_device_manager=0 # turn off 5g to save battery
        multisound_state=1 # Separate app sound enabled
        flip_font_style=3 # Display, Font size and style, roboto font
        # wfc_do_not_show_again_dt_emergency_location_dialog=1
        lock_screen_medical_info_access=1 # allow medical info on lockscreen
        google_core_control=0 # idk what it is but google..
        package_verifier_user_consent=-1 # play protect disable
        ota_disable_automatic_update=1 # with rooted ROM no auto updates anyway
    }

    $system = @{
        nearby_scanning_enabled=0 # disable nearby device scanning
        screen_off_timeout=600000 # screen timeout 10min
        auto_adjust_touch=1 # increase touch sensitivity
        screen_off_pocket=1 # accidental touch protection
        charging_info_always=1 # show charging info
        display_night_theme=1 # dark theme
        accelerometer_rotation=0 # disable auto rotate
        smart_capture_screenshot_format=PNG # use PNG for screenshots
        vset_enabled=0 # disable video call effects

        # below disable: Alert when phone picked up, mute with gestures, palm swipe to capture
        motion_merged_mute_pause=0
        motion_overturn=0
        motion_pick_up=0
        surface_palm_swipe=0
        surface_palm_touch=0

        direct_share=0 # disable 'show contacts when sharing content'
        show_password=0 # disable 'make passwords visible'
        display_battery_percentage=1 # display battery percentage
        simple_status_bar=1 # 0=show all notification icons, 1= show 3 most recent
        vibrate_when_ringing=1 # Enable vibrate when ringing
        show_notification_app_icon=1 # show app icon in notifications

        # set ringtone and notifications (make sure the files are available first)
        notification_sound="content://0@media/external/audio/media/1000000313?title=555154__nomerodin1__vibrating-message&canonical=1"
        notification_sound_CONSTANT_PATH="?path=%2Fstorage%2Femulated%2F0%2FNotifications%2F555154__nomerodin1__vibrating-message.mp3"
        ringtone="content://0@media/external/audio/media/1000000307?title=555154__nomerodin1__vibrating-message&canonical=1"
        ringtone_CONSTANT_PATH="?path=%2Fstorage%2Femulated%2F0%2FRingtones%2F555154__nomerodin1__vibrating-message.mp3"
        ringtone_vibration_sep_index=50035
        notification_vibration_sep_index=50083

        # System sound
        
        
        volume_system_earpiece=15
        volume_system_speaker=15
        sound_effects_enabled=0 # Touch interactions off
        dtmf_tone=0 # dialing keypad off
        sip_key_feedback_sound=0 # Samsung Keyboard sound
        lockscreen_sounds_enabled=0 # Screen lock/unlock sound
        

        camera_feedback_vibrate=0
        haptic_feedback_enabled=0
        sip_key_feedback_vibration=0
        navigation_gestures_vibrate=0

        # vibration Intensity
        VIB_FEEDBACK_MAGNITUDE=5
        SEM_VIBRATION_NOTIFICATION_INTENSITY=5
        VIB_RECVCALL_MAGNITUDE=5
        media_vibration_intensity=5

        # Sound and vibration > Volume
        volume_music_earpiece=0 # music volume 0
        volume_music_speaker=0 # music volume 0
        volume_notification_earpiece=13
        volume_notification_speaker=13
        volume_ring_earpiece=13
        volume_ring_speaker=13

        # Separate app sound
        multisound_devicetype=0 # output device 0 = Phone
        multisound_app="nl.flitsmeister:com.google.android.tts" # Flitemeister app

        # battery charging
        super_fast_charging=0
        adaptive_fast_charging=1
        wireless_fast_charging=1

        display_night_theme_wallpaper=0 # don't dim wallpaper in dark mode

        lock_editor_support_touch_hold=1 # touch and hold lock screen to edit
        homecity_timezone="Europe/Amsterdam" # Amsterdam home timezone for roaming clock

        lock_noticard_opacity=25 # notification details opacity in Settings->Lock screen-> Edit lock screen
        lockscreen_minimizing_notification=0 # 0=Show notification details
        custom_wallpaper_color_areas_lock="0:0:32-0.055555556:0.125:0.9456386:0.36291668;" # Enlarge clock

        # widget
        "add_info_com_samsung_android_app_routines#dashboard"=1 # remove routines from widget clock
        add_info_alarm=1 # add alarm info to widget clock
        add_info_music_control=1 # add music control to clock widget
        add_info_today_schedule=1 # add calendar info to clock widget

        access_control_use=0 # ?
        rcs_user_setting=0
    }

    $secure = @{
        wifi_mwips=0 # detect malware on wifi, turn off, don't scan my network omg!
        wifi_hotspot20_enable=0 # disable hotspot 2.0
        edge_enable=0 # edge panel, don't need it
        accessibility_button_mode=0 # use buttons for navigation
        navigation_mode=0 # use buttons for navigation
        ui_night_mode=2 # dark theme
        stylus_handwriting_enabled=0 # disable stylus handwriting MotionEvent
        game_home_enable=0 # disable gaming hub
        bluetooth_name=$device_name # set device name here
        bluetooth_cast_mode=0 # disable music share
        badge_app_icon_type=1 # app icon badges only show dots
        notification_history_enabled=1 # enable notification history
        secure_overlay_settings=1 # allow screen overlays on settings (battery drain issue)
        #icon_blacklist=battery
        charging_vibration_enabled=0 # disable vibration when charging
        notification_badging=1 # enable app notification badges
        charging_sounds_enabled=0 # system sound, disable charging sound
        lockdown_in_power_menu=1 # enable lockdown in power menu
        content_capture_enabled=0 # disable android personalization service from Google
        default_input_method="com.touchtype.swiftkey/com.touchtype.KeyboardService" # swiftkey kb as default kb
        # selected_input_method_subtype=2131165591 # ?
        show_keyboard_button=0 # disable keyboard button
        spell_checker_enabled=0 # disable samsung spellcheck
        tts_default_synth=com.google.android.tts # set default tts to google speech
        enabled_input_methods="com.samsung.android.honeyboard/.service.HoneyBoardService;65537:com.touchtype.swiftkey/com.touchtype.KeyboardService" # enable only samsung kb and swift key kb
        
        # for Automate accesibility shortcut
        accessibility_button_targets="com.llamalab.automate/com.llamalab.automate.AutomateAccessibilityButtonService"
        accessibility_enabled=1
        accessibility_magnification_shortcut=0
        enabled_accessibility_services="com.llamalab.automate/com.llamalab.automate.AutomateAccessibilityButtonService:com.llamalab.automate/com.llamalab.automate.AutomateAccessibilityService"

        immersive_mode_confirmations=confirmed # no need for popup how to use nav buttons on screen-only phones

        # select tiles in extra dropdown
        sysui_qs_tiles="SoundMode,RotationLock,AirplaneMode,Flashlight,MobileData,Hotspot,Location,custom(com.samsung.android.app.smartcapture/com.samsung.android.app.screenrecorder.view.RecordScreenTile),Dnd,custom(com.shazam.android/com.shazam.popup.android.service.FloatingShazamTileService),custom(com.wireguard.android/.QuickTileService)"
        sysui_removed_qs_tiles="custom(com.sec.unifiedwfc/.ux.quicksettings.WFCQSTileService),custom(com.sec.android.app.camera/.service.QrTileService),custom(com.samsung.android.lool/com.samsung.android.sm.battery.ui.mode.BatteryModeTile)"
        
        # autofill
        autofill_service="keepass2android.keepass2android/keepass2android.services.Kp2aAutofillService" # setup KP2A as autofill
        credential_service="com.google.android.gms/com.google.android.gms.auth.api.credentials.credman.service.PasswordAndPasskeyService"
        
        media_button_receiver="com.spotify.music/com.spotify.mediasession.mediasession.receiver.MediaButtonReceiver,0,1"

        client_advanced_autohotspot_run=0
        enabled_notification_listeners="com.llamalab.automate/com.llamalab.automate.AutomateNotificationListenerServiceKitKat:com.sec.android.app.launcher/com.android.launcher3.notification.NotificationListener"
        show_zen_settings_suggestion=0
    }

    ADB-Change-Service -Key nfc -Value disable # turn off nfc
    ADB-Change-Settings-List -Namespace "global" -Array $global
    ADB-Change-Settings-List -Namespace "system" -Array $system
    ADB-Change-Settings-List -Namespace "secure" -Array $secure
}

ADB-Change-Settings


adb shell pm disable com.google.android.gms/.nearby.discovery.service.DiscoveryService
adb shell pm disable com.google.android.gms/.nearby.sharing.DirectShareService
