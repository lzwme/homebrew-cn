cask "vallum" do
  version "4.1.3"
  sha256 "b22934ea092f06cd4261f5508c230ac4a0a920a9c7fd8ca1f14ebf8e66818114"

  url "https:github.comTheMurusTeamVallumreleasesdownloadv#{version}vallum-#{version}.zip",
      verified: "github.comTheMurusTeamVallum"
  name "Vallum"
  desc "Application firewall"
  homepage "https:www.vallumfirewall.com"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :catalina"

  app "Vallum.app"

  uninstall launchctl: [
              "it.murus.afw.core",
              "it.murus.afw.helper",
            ],
            pkgutil:   "it.murus.afw.Vallum"

  zap trash: "~LibraryPreferencesit.murus.Vallum.plist"
end