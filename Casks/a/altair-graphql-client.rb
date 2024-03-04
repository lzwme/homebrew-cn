cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "6.3.1"
  sha256 arm:   "8e890d495248edb6865f3f3590e2df250549141de81d0616e4d72ec9fed27483",
         intel: "70427ae6339a9b804ecb5b1f9838e9d1136488aa542902fb4441b440edda4f7c"

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