cask "vallum" do
  version "5.0.3"
  sha256 "8f63c3c7da0cb4db65fcb6774103f20679058ae9e0febf215848ac6304836726"

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