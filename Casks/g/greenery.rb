cask "greenery" do
  version "0.9.11"
  sha256 "36fe169fe95f136b79d70eeb917e74d7742671f22f33634349012a75da0e5131"

  url "https:github.comGreenfireIncReleases.Greeneryreleasesdownloadv#{version}Greenery.#{version}.zip",
      verified: "github.comGreenfireIncReleases.Greenery"
  name "Greenery"
  desc "Cryptocurrency bookkeeping and accounting wallet"
  homepage "https:www.greenery.finance"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Greenery.app"

  zap trash: [
    "~LibraryApplication SupportGreenery",
    "~LibraryPreferencescom.greenery.app.plist",
    "~LibrarySaved Application Statecom.greenery.app.savedState",
  ]
end