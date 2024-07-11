cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "7.2.4"
  sha256 arm:   "a6f234b2d979b35b4801b50e44778633640d8c7f84426000f3bf636d2b679f8c",
         intel: "078a4279a6c148d8f3c94fb9c3167900b2b50c9b0722c8ee4f060b113e15df13"

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