cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "6.0.2"
  sha256 arm:   "f4f556240ac31c5da20313465344120a6a64f5d0f1343e31000df1d77551b37d",
         intel: "4ceca542d7967c116d7cd037ae5b66afa7a158359e2c41848f1f911450eb4eef"

  url "https:github.comimolorhealtairreleasesdownloadv#{version}altair_#{version}_#{arch}_mac.zip",
      verified: "github.comimolorhealtair"
  name "Altair GraphQL Client"
  desc "GraphQL client"
  homepage "https:altair.sirmuel.design"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Altair GraphQL Client.app"

  zap trash: [
    "~LibraryApplication Supportaltair",
    "~LibraryPreferencescom.electron.altair.helper.plist",
    "~LibraryPreferencescom.electron.altair.plist",
    "~LibrarySaved Application Statecom.electron.altair.savedState",
  ]
end