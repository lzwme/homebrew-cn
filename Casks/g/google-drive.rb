cask "google-drive" do
  version "101.0.3"
  sha256 :no_check

  # "5-percent" is included in the url to ensure that `brew upgrade` does not update to an older version as the
  # in-app updater can upgrade to a new version than https:dl.google.comdrive-file-streamGoogleDrive.dmg provides
  url "https:dl.google.comdrive-file-stream5-percentGoogleDrive.dmg"
  name "Google Drive"
  desc "Client for the Google Drive storage service"
  homepage "https:www.google.comdrive"

  livecheck do
    url :url
    strategy :extract_plist do |item|
      item["com.google.drivefs"]&.version
    end
  end

  auto_updates true
  depends_on macos: ">= :el_capitan"

  pkg "GoogleDrive.pkg"

  # Some launchctl and pkgutil items are shared with other Google apps, they should only be removed in the zap stanza
  # See: https:github.comHomebrewhomebrew-caskpull92704#issuecomment-727163169
  # launchctl: com.google.GoogleUpdater.wake.system, com.google.keystone.daemon,
  #            com.google.keystone.system.agent, com.google.keystone.system.xpcservice

  # pkgutil: com.google.pkg.Keystone
  uninstall quit:       [
              "com.google.drivefs",
              "com.google.drivefs.finderhelper.findersync",
            ],
            login_item: "Google Drive",
            pkgutil:    [
              "com.google.drivefs.arm64",
              "com.google.drivefs.filesystems.dfsfuse.arm64",
              "com.google.drivefs.filesystems.dfsfuse.x86_64",
              "com.google.drivefs.shortcuts",
              "com.google.drivefs.x86_64",
            ]

  zap launchctl: [
        "com.google.GoogleUpdater.wake.system",
        "com.google.keystone.agent",
        "com.google.keystone.daemon",
        "com.google.keystone.system.agent",
        "com.google.keystone.system.xpcservice",
        "com.google.keystone.xpcservice",
      ],
      pkgutil:   "com.google.pkg.Keystone",
      trash:     [
        "~LibraryApplication Scriptscom.google.drivefs*",
        "~LibraryApplication ScriptsEQHXZ8M8AV.group.com.google.drivefs",
        "~LibraryApplication SupportFileProvidercom.google.drivefs.fpext",
        "~LibraryApplication SupportGoogleDriveFS",
        "~LibraryCachescom.google.drivefs",
        "~LibraryContainerscom.google.drivefs*",
        "~LibraryGroup Containers*group.com.google.drivefs",
        "~LibraryPreferencescom.google.drivefs*.plist",
        "~LibraryPreferencesGoogle Drive File Stream Helper.plist",
      ]
end