cask "greenery" do
  version "0.9.7"
  sha256 "c2c0d298585d443eb6dde267d744d7f92283ff586709ef7582f0cfa4812722a0"

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