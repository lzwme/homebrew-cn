cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.38.3"
  sha256 arm:   "13d1ff76963aa948cde4642ab407410d543da34a7c9e3b8364b2ee13f82254cb",
         intel: "fb5df24e8f7803bb742d10865aee3141eb81660e2466bbca31cb9b4f179c1504"

  url "https:github.comrotkirotkireleasesdownloadv#{version}rotki-darwin_#{arch}-v#{version}.dmg",
      verified: "github.comrotkirotki"
  name "Rotki"
  desc "Portfolio tracking and accounting tool"
  homepage "https:rotki.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "rotki.app"

  zap trash: [
    "~LibraryApplication Supportrotki",
    "~LibraryPreferencescom.rotki.app.plist",
    "~LibrarySaved Application Statecom.rotki.app.savedState",
  ]
end