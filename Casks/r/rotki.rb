cask "rotki" do
  arch arm: "arm64", intel: "x64"

  version "1.39.1"
  sha256 arm:   "dd2b55c0d21bcfb670cd28f3e644a49ebcbe28d5a6d683d7abb5e1f71b56e397",
         intel: "51005372058ad3575ef965394039075899b9841cfbe03e836c38bc8f5c405869"

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