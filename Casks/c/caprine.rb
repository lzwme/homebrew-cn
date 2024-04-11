cask "caprine" do
  arch arm: "-arm64"

  version "2.60.1"
  sha256 arm:   "fc2ae78afb4e7b4e9dbac3e3626402e8530423fe1d225f6115bd7f2d85e7e7be",
         intel: "df389cd803ade6ab3bb1e106054255536b8dcfdf4624d9e05b3538aac21daee2"

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