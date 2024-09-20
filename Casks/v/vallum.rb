cask "vallum" do
  version "5.0"
  sha256 "e43197bbd690f90ef99b00eb53854cef1019afb3713c8ac76779633af11a1feb"

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