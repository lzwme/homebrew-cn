cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.0.5"
  sha256 arm:   "d1695d560e18daf3089fdc8188b9dd599e9fd1be3a6839417e68e2580749879b",
         intel: "43b135da9845937e77e41fd5bd0856df0890c1686d58bf45c8258291541d7515"

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