cask "caprine" do
  arch arm: "-arm64"

  version "2.60.2"
  sha256 arm:   "dfd61e8dd26c06a2049ff9cf05a75848153645dde3499e2a1327c3c1d79a2d19",
         intel: "33ae74206c1df87af5615ac9b4fcebb048c566d599c7e9284e9dad96b11213c0"

  url "https:github.comsindresorhuscaprinereleasesdownloadv#{version}Caprine-#{version}#{arch}.dmg"
  name "Caprine"
  desc "Elegant Facebook Messenger desktop app"
  homepage "https:github.comsindresorhuscaprine"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Caprine.app"

  zap trash: [
    "~LibraryApplication SupportCaprine",
    "~LibraryCachescom.sindresorhus.caprine",
    "~LibraryCachescom.sindresorhus.caprine.ShipIt",
    "~LibraryLogsCaprine",
    "~LibraryPreferencescom.sindresorhus.caprine.helper.plist",
    "~LibraryPreferencescom.sindresorhus.caprine.plist",
    "~LibrarySaved Application Statecom.sindresorhus.caprine.savedState",
  ]
end