cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.0.0"
  sha256 arm:   "58301404cdfacf3ca099fdeab15a4b662b25a73d76be09e240e6e27470971002",
         intel: "104b55ebf790a9c39e23786a3878399e22087c1be4ace1f2af7522935916481d"

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