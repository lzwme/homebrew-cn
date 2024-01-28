cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "6.2.0"
  sha256 arm:   "9f1eee491d293d731c8cb7db3dcc9fd306a22985571edae35bf64f331094fece",
         intel: "7b742b513c07d449e951d8a27a9a3987ba38d244d1e49a847040ae553e49838e"

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