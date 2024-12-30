cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.1.1"
  sha256 arm:   "6d4fa9c5c18a573b3633219d8c25389664e423fb0f9241def431c4655747fdd8",
         intel: "48b2e6b883b55ec9e92ab546042834de6769e19f0d71cdc536178a2750246a27"

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