cask "greenery" do
  version "0.9.10"
  sha256 "7323eda1fe0c48b74462c20d2de0e1c9a0ed0bff7991d290bc5faad5021f8e2c"

  url "https:github.comGreenfireIncReleases.Greeneryreleasesdownloadv#{version}Greenery.#{version}.zip",
      verified: "github.comGreenfireIncReleases.Greenery"
  name "Greenery"
  desc "Cryptocurrency bookkeeping and accounting wallet"
  homepage "https:www.greenery.finance"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Greenery.app"

  zap trash: [
    "~LibraryApplication SupportGreenery",
    "~LibraryPreferencescom.greenery.app.plist",
    "~LibrarySaved Application Statecom.greenery.app.savedState",
  ]
end