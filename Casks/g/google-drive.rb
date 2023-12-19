cask "google-drive" do
  version "85.0.26"
  sha256 :no_check

  # "5-percent" is included in the url to ensure that `brew upgrade` does not update to an older version as the
  # in-app updater can upgrade to a new version than https:dl.google.comdrive-file-streamGoogleDrive.dmg provides
  url "https:dl.google.comdrive-file-stream5-percentGoogleDrive.dmg"
  name "Google Drive"
  desc "Client for the Google Drive storage service"
  homepage "https:www.google.comdrive"

  livecheck do
    url :url
    strategy :extract_plist
  end

  auto_updates true
  depends_on macos: ">= :el_capitan"

  pkg "GoogleDrive.pkg"

  # Some launchctl and pkgutil items are shared with other Google apps, they should only be removed in the zap stanza
  # See: https:github.comHomebrewhomebrew-caskpull92704#issuecomment-727163169
  # launchctl: com.google.keystone.daemon, com.google.keystone.system.agent, com.google.keystone.system.xpcservice
  # pkgutil: com.google.pkg.Keystone
  uninstall login_item: "Google Drive",
            quit:       [
              "com.google.drivefs",
              "com.google.drivefs.finderhelper.findersync",
            ],
            pkgutil:    [
              "com.google.drivefs.arm64",
              "com.google.drivefs.filesystems.dfsfuse.arm64",
              "com.google.drivefs.filesystems.dfsfuse.x86_64",
              "com.google.drivefs.shortcuts",
              "com.google.drivefs.x86_64",
            ]

  zap trash:     [
        "~LibraryApplication Scriptscom.google.drivefs.finderhelper.findersync",
        "~LibraryApplication Scriptscom.google.drivefs.finderhelper",
        "~LibraryApplication Scriptscom.google.drivefs.fpext",
        "~LibraryApplication SupportFileProvidercom.google.drivefs.fpext",
        "~LibraryApplication SupportGoogleDriveFS",
        "~LibraryCachescom.google.drivefs",
        "~LibraryContainerscom.google.drivefs.finderhelper.findersync",
        "~LibraryContainerscom.google.drivefs.finderhelper",
        "~LibraryContainerscom.google.drivefs.fpext",
        "~LibraryGroup ContainersEQHXZ8M8AV.group.com.google.drivefs",
        "~LibraryGroup Containersgroup.com.google.drivefs",
        "~LibraryPreferencescom.google.drivefs.helper.renderer.plist",
        "~LibraryPreferencescom.google.drivefs.plist",
        "~LibraryPreferencescom.google.drivefs.settings.plist",
        "~LibraryPreferencesGoogle Drive File Stream Helper.plist",
      ],
      launchctl: [
        "com.google.keystone.agent",
        "com.google.keystone.daemon",
        "com.google.keystone.system.agent",
        "com.google.keystone.system.xpcservice",
        "com.google.keystone.xpcservice",
      ],
      pkgutil:   "com.google.pkg.Keystone"
end