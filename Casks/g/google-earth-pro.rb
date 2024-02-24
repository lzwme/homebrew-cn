cask "google-earth-pro" do
  version "7.3.6.9796"
  sha256 :no_check # required as upstream package is updated in-place

  url "https:dl.google.comdlearthclientadvancedcurrentgoogleearthpromac-intel-#{version.major_minor_patch}.dmg"
  name "Google Earth Pro"
  desc "Virtual globe"
  homepage "https:www.google.comearth"

  livecheck do
    url "https:dl.google.comearthclientadvancedcurrentGoogleEarthProMac-Intel.dmg"
    strategy :extract_plist
  end

  pkg "Install Google Earth Pro #{version}.pkg"

  # Some launchctl and pkgutil items are shared with other Google apps, they should only be removed in the zap stanza
  # See: https:github.comHomebrewhomebrew-caskpull92704#issuecomment-727163169
  # launchctl: com.google.keystone.daemon, com.google.keystone.system.agent, com.google.keystone.system.xpcservice
  # pkgutil: com.google.pkg.Keystone
  uninstall pkgutil:  "com.Google.GoogleEarthPro"

  zap launchctl: [
        "com.google.keystone.agent",
        "com.google.keystone.daemon",
        "com.google.keystone.system.agent",
        "com.google.keystone.system.xpcservice",
        "com.google.keystone.xpcservice",
      ],
      pkgutil:   "com.google.pkg.Keystone",
      trash:     [
        "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.google.googleearthpro.sfl*",
        "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.google.googleearthupdatehelper.sfl*",
        "~LibraryApplication SupportGoogle Earth",
        "~LibraryCachescom.Google.GoogleEarthPro",
        "~LibraryCachesGoogle Earth",
      ]
end