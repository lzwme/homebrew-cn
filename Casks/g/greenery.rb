cask "greenery" do
  version "0.9.7"
  sha256 "5f062694ea82a4e97ed248b896cb7c565437a8c36221aeb85df28f97d2e78a12"

  url "https:github.comGreenfireIncReleases.Greeneryreleasesdownloadv#{version}Greenery.#{version}.zip",
      verified: "github.comGreenfireIncReleases.Greenery"
  name "Greenery"
  desc "Cryptocurrency bookkeeping and accounting wallet"
  homepage "https:www.greenery.finance"

  depends_on macos: ">= :high_sierra"

  app "Greenery.app"

  zap trash: [
    "~LibraryApplication SupportGreenery",
    "~LibraryPreferencescom.greenery.app.plist",
    "~LibrarySaved Application Statecom.greenery.app.savedState",
  ]
end