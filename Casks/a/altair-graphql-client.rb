cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "7.0.0"
  sha256 arm:   "16e4d8bd66d94623bac8f3254ba419f6b4887aceb33091ed21837251c7042801",
         intel: "fcb58e4c7fd55448953a301c755abf25e3849f4e8ec68f6232eba4ab6a8dac59"

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