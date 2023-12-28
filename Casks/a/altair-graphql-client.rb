cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "6.1.0"
  sha256 arm:   "ddae2a85137610685c30da5a8be128f2ebe3df9f66565fad409512e7039b6704",
         intel: "1e64488af6e706e3a9e9a2864d390995de39a475a610360c953772e8663ccbf1"

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