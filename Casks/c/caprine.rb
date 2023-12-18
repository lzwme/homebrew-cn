cask "caprine" do
  arch arm: "-arm64"

  version "2.59.1"
  sha256 arm:   "eec8b899e2e7119bb92b65edf37062ae1f993b043f55ced17102ba7a83aee29d",
         intel: "58c4f8cab2e30d232c23f9456d8383bb7ff4c21705fbefb84a1a0285f3322df4"

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