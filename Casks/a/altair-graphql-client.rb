cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "7.0.1"
  sha256 arm:   "3093a7872db9317162b76b0cc3def45bfc6428a187c2290933faf78a66885a76",
         intel: "293b0846f1c744410a71c4a239cfddf38753fff5eb15496fdd1126a85e84ac35"

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