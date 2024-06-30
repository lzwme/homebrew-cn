cask "cloudflare-warp" do
  version "2024.6.416.0,20240628.6"
  sha256 "d3336cedf6e835408bd8cb3122c3fad26374faca910da0b96171ad59b0020dd6"

  url "https:1111-releases.cloudflareclient.commacCloudflare_WARP_#{version.csv.first}.pkg",
      verified: "1111-releases.cloudflareclient.commac"
  name "Cloudflare WARP"
  desc "Free app that makes your Internet safer"
  homepage "https:cloudflarewarp.com"

  livecheck do
    # :sparkle strategy using appcenter url cannot be used - see below link
    # https:github.comHomebrewhomebrew-caskpull109118#issuecomment-887184248
    url "https:1111-releases.cloudflareclient.commacCloudflare_WARP.zip"
    strategy :extract_plist
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  pkg "Cloudflare_WARP_#{version.csv.first}.pkg"

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