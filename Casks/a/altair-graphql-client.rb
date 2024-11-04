cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.0.1"
  sha256 arm:   "6f0dbd23c2c8a539264a770cfa1e7b5fd04a7b3699339c38ca3fa96fae107cbf",
         intel: "daea06d4e687f4aad9f9b248f92ade91a76bab3db053e92732cb038672d6aa58"

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