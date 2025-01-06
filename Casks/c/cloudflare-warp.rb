cask "cloudflare-warp" do
  version "2024.12.554.0"
  sha256 "1cc6d8a35452216165000266e13a03ac893dfc6b13302ea226fea6357c907a6d"

  url "https:1111-releases.cloudflareclient.commacCloudflare_WARP_#{version}.pkg",
      verified: "1111-releases.cloudflareclient.commac"
  name "Cloudflare WARP"
  desc "Free app that makes your Internet safer"
  homepage "https:cloudflarewarp.com"

  livecheck do
    # :sparkle strategy using appcenter url cannot be used - see below link
    # https:github.comHomebrewhomebrew-caskpull109118#issuecomment-887184248
    url "https:1111-releases.cloudflareclient.commaclatest"
    regex(Cloudflare[._-]WARP[._-]v?(\d+(?:\.\d+)+)\.pkgi)
    strategy :header_match
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  pkg "Cloudflare_WARP_#{version}.pkg"

  uninstall launchctl: [
              "com.cloudflare.1dot1dot1dot1.macos.loginlauncherapp",
              "com.cloudflare.1dot1dot1dot1.macos.warp.daemon",
            ],
            quit:      "com.cloudflare.1dot1dot1dot1.macos",
            pkgutil:   "com.cloudflare.1dot1dot1dot1.macos"

  zap trash: [
    "LibraryLaunchDaemonscom.cloudflare.1dot1dot1dot1.macos.warp.daemon.plist",
    "~LibraryApplication Scriptscom.cloudflare.1dot1dot1dot1.macos.loginlauncherapp",
    "~LibraryApplication Supportcom.cloudflare.1dot1dot1dot1.macos",
    "~LibraryCachescom.cloudflare.1dot1dot1dot1.macos",
    "~LibraryCachescom.plausiblelabs.crashreporter.datacom.cloudflare.1dot1dot1dot1.macos",
    "~LibraryContainerscom.cloudflare.1dot1dot1dot1.macos.loginlauncherapp",
    "~LibraryHTTPStoragescom.cloudflare.1dot1dot1dot1.macos",
    "~LibraryHTTPStoragescom.cloudflare.1dot1dot1dot1.macos.binarycookies",
    "~LibraryPreferencescom.cloudflare.1dot1dot1dot1.macos.plist",
    "~LibraryWebKitcom.cloudflare.1dot1dot1dot1.macos",
  ]
end