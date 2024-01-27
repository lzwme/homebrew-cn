cask "cloudflare-warp" do
  version "2024.1.160.0,20240124.7"
  sha256 :no_check

  url "https:1111-releases.cloudflareclient.commacCloudflare_WARP.zip",
      verified: "1111-releases.cloudflareclient.commac"
  name "Cloudflare WARP"
  desc "Free app that makes your Internet safer"
  homepage "https:cloudflarewarp.com"

  livecheck do
    # :sparkle strategy using appcenter url cannot be used - see below link
    # https:github.comHomebrewhomebrew-caskpull109118#issuecomment-887184248
    url :url
    strategy :extract_plist
  end

  auto_updates true

  pkg "Cloudflare_WARP.pkg"

  uninstall launchctl: "com.cloudflare.1dot1dot1dot1.macos.loginlauncherapp",
            script:    {
              executable: "ApplicationsCloudflare WARP.appContentsResourcesuninstall.sh",
              input:      ["Y\n"],
              sudo:       true,
            }

  zap trash: [
    "~LibraryApplication Scriptscom.cloudflare.1dot1dot1dot1.macos.loginlauncherapp",
    "~LibraryApplication Supportcom.cloudflare.1dot1dot1dot1.macos",
    "~LibraryCachescom.cloudflare.1dot1dot1dot1.macos",
    "~LibraryCachescom.plausiblelabs.crashreporter.datacom.cloudflare.1dot1dot1dot1.macos",
    "~LibraryContainerscom.cloudflare.1dot1dot1dot1.macos.loginlauncherapp",
    "~LibraryHTTPStoragescom.cloudflare.1dot1dot1dot1.macos",
    "~LibraryHTTPStoragescom.cloudflare.1dot1dot1dot1.macos.binarycookies",
    "~LibraryPreferencescom.cloudflare.1dot1dot1dot1.macos.plist",
  ]
end