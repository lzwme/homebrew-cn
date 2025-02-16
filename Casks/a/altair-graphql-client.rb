cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.1.5"
  sha256 arm:   "1122053fbe93bfa1fc18bd54afa810435fdb0a9810563f63cce2fb3d9f91ffcf",
         intel: "050c42f8913b8cae4b0882423bc3c6698782605864e102ae02d8f7c5e90ffae6"

  url "https:github.comimolorhealtairreleasesdownloadv#{version}altair_#{version}_#{arch}_mac.zip",
      verified: "github.comimolorhealtair"
  name "Altair GraphQL Client"
  desc "GraphQL client"
  homepage "https:altair.sirmuel.design"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Altair GraphQL Client.app"

  zap trash: [
    "~LibraryApplication Supportaltair",
    "~LibraryPreferencescom.electron.altair.helper.plist",
    "~LibraryPreferencescom.electron.altair.plist",
    "~LibrarySaved Application Statecom.electron.altair.savedState",
  ]
end