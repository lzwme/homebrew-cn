cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "7.2.2"
  sha256 arm:   "8ac20d5313f33b45b145a0bc76df5e2b1318ea0d31652225f4546e5f00ee6345",
         intel: "81b8ee55bb6e6c0cf54e2b8a584a2afb185b66df5eefcc8af1f2104ed8f557c1"

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