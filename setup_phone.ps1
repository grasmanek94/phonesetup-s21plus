Set-Location -Path "$PSScriptRoot"

function APK-Install {
    param(
        $APKFile
    )

    adb install --bypass-low-target-sdk-block "$APKFile"
}

function APK-Install-All {
    Get-ChildItem "$PSScriptRoot\apk\" -Filter *.apk | 
    Foreach-Object {
        APK-Install -APKFile $_.FullName
    }
}

function Android-Package-Disable {
    param(
        $Package
    )

    adb shell pm disable-user --user 0 "$Package"
}

function Android-Package-Disable-All {
    $packages_to_disable = @(
        'com.samsung.android.wifi.ai',
        'com.samsung.android.scpm',
        'com.samsung.android.smartsuggestions',
        'com.samsung.android.scs',
        'com.samsung.android.inputshare',
        'com.samsung.android.mcfds',
        'com.google.android.youtube',
        'com.google.android.apps.messaging',
        'com.samsung.android.app.tips',
        'com.facebook.katana',
        'android.autoinstalls.config.samsung',
        'com.android.calllogbackup',
        'com.android.dreams.phototable',
	    'com.android.bluetoothmidiservice',
	    'com.android.calllogbackup',
	    'com.android.dreams.basic',
	    'com.android.dreams.phototable',
	    'com.android.egg',
	    'com.android.hotwordenrollment.okgoogle',
	    'com.android.hotwordenrollment.xgoogle',
	    'com.android.providers.partnerbookmarks',
	    'com.android.wallpaper.livepicker',
	    'com.diotek.sec.lookup.dictionary',
	    'com.facebook.appmanager',
	    'com.facebook.services',
	    'com.facebook.system',
	    'com.google.android.apps.restore',
	    'com.google.android.apps.setupwizard.searchselector',
	    'com.google.android.apps.tachyon',
	    'com.google.android.as',
	    'com.google.android.feedback',
	    'com.google.android.googlequicksearchbox',
	    'com.google.android.onetimeinitializer',
	    'com.google.android.partnersetup',
	    'com.google.android.printservice.recommendation',
	    'com.google.android.projection.gearhead',
	    'com.google.ar.core',
	    'com.google.audio.hearing.visualization.accessibility.scribe',
	    'com.hiya.star',
	    'com.knox.vpn.proxyhandler',
	    'com.microsoft.appmanager',
	    'com.microsoft.skydrive',
	    'com.netflix.partner.activation',
	    'com.osp.app.signin',
	    'com.samsung.SMT',
	    'com.samsung.aasaservice',
	    'com.samsung.android.aircommandmanager',
	    'com.samsung.android.allshare.service.mediashare',
	    'com.samsung.android.app.appsedge',
	    'com.samsung.android.app.camera.sticker.facearavatar.preload',
	    'com.samsung.android.app.clipboardedge',
	    'com.samsung.android.app.cocktailbarservice',
	    'com.samsung.android.app.ledbackcover',
	    'com.samsung.android.app.omcagent',
	    'com.samsung.android.app.reminder',
	    'com.samsung.android.app.routines',
	    'com.samsung.android.app.settings.bixby',
	    'com.samsung.android.app.spage',
	    'com.samsung.android.app.taskedge',
	    'com.samsung.android.app.watchmanagerstub',
	    'com.samsung.android.ardrawing',
	    'com.samsung.android.aremoji',
	    'com.samsung.android.aremojieditor',
	    'com.samsung.android.arzone',
	    'com.samsung.android.authfw',
	    'com.samsung.android.aware.service',
	    'com.samsung.android.bbc.bbcagent',
	    'com.samsung.android.beaconmanager',
	    'com.samsung.android.bixby.agent',
	    'com.samsung.android.bixby.wakeup',
	    'com.samsung.android.bixbyvision.framework',
	    'com.samsung.android.da.daagent',
	    'com.samsung.android.dqagent',
	    'com.samsung.android.dynamiclock',
	    'com.samsung.android.easysetup',
	    'com.samsung.android.fast',
	    'com.samsung.android.fmm',
	    'com.samsung.android.forest',
	    'com.samsung.android.game.gametools',
	    'com.samsung.android.game.gos',
	    'com.samsung.android.ipsgeofence',
	    'com.samsung.android.kidsinstaller',
	    'com.samsung.android.knox.analytics.uploader',
	    'com.samsung.android.knox.attestation',
	    'com.samsung.android.knox.containercore',
	    'com.samsung.android.knox.pushmanager',
	    'com.samsung.android.location',
	    'com.samsung.android.mcfserver',
	    'com.samsung.android.mdecservice',
	    'com.samsung.android.mdm',
	    'com.samsung.android.mdx',
	    'com.samsung.android.mdx.kit',
	    'com.samsung.android.mobileservice',
	    'com.samsung.android.net.wifi.wifiguider',
	    'com.samsung.android.networkdiagnostic',
	    'com.samsung.android.rubin.app',
	    'com.samsung.android.samsungpass',
	    'com.samsung.android.samsungpassautofill',
	    'com.samsung.android.samsungpositioning',
	    'com.samsung.android.scloud',
	    'com.samsung.android.sdk.handwriting',
	    'com.samsung.android.sdm.config',
	    'com.samsung.android.service.peoplestripe',
	    'com.samsung.android.shortcutbackupservice',
	    'com.samsung.android.sm.devicesecurity',
	    'com.samsung.android.smartcallprovider',
	    'com.samsung.android.smartmirroring',
	    'com.samsung.android.smartswitchassistant',
	    'com.samsung.android.spayfw',
	    'com.samsung.android.stickercenter',
	    'com.samsung.android.svcagent',
	    'com.samsung.android.svoiceime',
	    'com.samsung.android.visionintelligence',
	    'com.samsung.android.wifi.softap.resources',
	    'com.samsung.crane',
	    'com.samsung.faceservice',
	    'com.samsung.ipservice',
	    'com.samsung.klmsagent',
	    'com.samsung.knox.securefolder',
	    'com.samsung.safetyinformation',
	    'com.samsung.storyservice',
	    'com.samsung.ucs.agent.ese',
	    'com.sec.android.app.DataCreate',
	    'com.sec.android.app.SecSetupWizard',
	    'com.sec.android.app.billing',
	    'com.sec.android.app.chromecustomizations',
	    'com.sec.android.app.desktoplauncher',
	    'com.sec.android.app.dexonpc',
	    'com.sec.android.app.factorykeystring',
	    'com.sec.android.app.quicktool',
	    'com.sec.android.app.samsungapps',
	    'com.sec.android.app.setupwizardlegalprovider',
	    'com.sec.android.cover.ledcover',
	    'com.sec.android.desktopmode.uiservice',
	    # 'com.sec.android.diagmonagent', # seems to drain battery when disabled due to OS trying to start it
	    'com.sec.android.easyMover',
	    'com.sec.android.easyMover.Agent',
	    'com.sec.android.easyonehand',
	    'com.sec.android.mimage.avatarstickers',
	    'com.sec.android.widgetapp.webmanual',
	    'com.sec.enterprise.knox.cloudmdm.smdms',
	    'com.sec.enterprise.mdm.services.simpin',
	    'com.sec.imslogger',
	    'com.sec.location.nsflp2',
	    'com.sec.modem.settings',
	    'com.sec.spp.push',
	    'de.axelspringer.yana.zeropage',
        'com.samsung.android.app.sharelive',
        'com.samsung.android.themestore',
        'com.samsung.android.rampart',
        'com.samsung.android.mapsagent',
        'com.samsung.android.app.updatecenter',
        'com.wssyncmldm', # no OTA on rooted devices anyway
        'com.sec.android.soagent', # no OTA on rooted devices anyway
        'com.google.android.nearby.halfsheet', # Also Nearby Sharing?
        'com.sec.android.daemonapp', # weather
        'com.samsung.sec.android.teegris.tui_service', # not used for consumer applications, although I think adb can't really disable this, magisk module needed
        'com.google.android.apps.turbo', # calculate remaining battery percentage based on usage? I saw no effect when disabling, ans samsung has their own service for it..
        'com.samsung.android.vtcamerasettings', # video call effects?
        'com.samsung.android.visualars',
        'com.samsung.android.knox.kpecore',
        'com.google.android.adservices.api',
        # 'com.google.mainline.adservices', # bricks phone? https://xdaforums.com/t/guide-how-to-fix-google-play-system-update-not-updating-or-being-stuck.4459903/post-88193383 # although maybe the user deleted another core service, others report it's fine
        'com.sec.bcservice'

    )

    $packages_to_disable | Foreach-Object {
        Android-Package-Disable -Package $_
    }
}

function SSH-PubKey-Upload {
    # make sure to give root permissions from Magisk for these actions
    adb shell "su -c mkdir -p /data/ssh/root/.ssh/" 
    adb push "$PSScriptRoot\ssh\authorized_keys" "/sdcard/Download/"
    adb shell "su -c mv /sdcard/Download/authorized_keys /data/ssh/root/.ssh/"
    adb shell "su -c chown -R root:root /data/ssh/root/"    
    adb shell "su -c chmod 0600 /data/ssh/root/.ssh/authorized_keys"
}

APK-Install-All
Android-Package-Disable-All
SSH-PubKey-Upload
