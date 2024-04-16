cask "bruno" do
  arch arm: "arm64", intel: "x64"

  version "1.13.1"
  sha256 arm:   "0e45cf5ca6734b5bca780780204fc826101d35c485cf40fd306013ac83ad462c",
         intel: "88cb9f245754e697541ec5d8c799881312be9a796960f9a75dcd173cf904c379"

  url "https:github.comusebrunobrunoreleasesdownloadv#{version}bruno_#{version}_#{arch}_mac.dmg",
      verified: "github.comusebrunobruno"
  name "Bruno"
  desc "Opensource IDE for exploring and testing api's"
  homepage "https:www.usebruno.com"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Bruno.app"

  zap trash: [
    "~LibraryApplication Supportbruno",
    "~LibraryPreferencescom.usebruno.app.plist",
    "~LibrarySaved Application Statecom.usebruno.app.savedState",
  ]
end