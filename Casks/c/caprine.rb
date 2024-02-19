cask "caprine" do
  arch arm: "-arm64"

  version "2.59.2"
  sha256 arm:   "25a9f48d8d490dc019e427162a78577717bfe0a52d0b49d8534948f5efd1e434",
         intel: "31d493e996cd3c7bef234925cdce979c526dc24c89caef4232d36203daeb2e2d"

  url "https:github.comsindresorhuscaprinereleasesdownloadv#{version}Caprine-#{version}#{arch}.dmg"
  name "Caprine"
  desc "Elegant Facebook Messenger desktop app"
  homepage "https:github.comsindresorhuscaprine"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

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