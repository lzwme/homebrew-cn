cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "6.4.0"
  sha256 arm:   "6aa11b082a25c4044ebcaee993b395e41a5041d6fe462dc77d45872c97eb3e70",
         intel: "24f2c5304b70a6991586c29dc883f7df0a2d47454429c7a49ced0dd25b6f4c1e"

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