cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.0.3"
  sha256 arm:   "5509b80af00786d56fab696f861bda5aac2da5eead640f50b94d45718a549304",
         intel: "c0d8e1b0fcafb0bed8cd482e0f87c555966b0a66db8d7b51165ed6f18218b7ab"

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