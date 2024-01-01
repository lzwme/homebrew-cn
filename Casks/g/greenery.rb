cask "greenery" do
  version "0.9.5"
  sha256 "c1c8e6ccd88b054af604c37a3dc62c451d352e14e5626249b022fbcd23bbaf08"

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