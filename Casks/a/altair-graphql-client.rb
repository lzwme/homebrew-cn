cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.2.0"
  sha256 arm:   "e83af5aa9b2fabe7016ed0414dbefbb6a47548e866c7a6847b0277be7931e9f0",
         intel: "fd8f715aaa890588a4549ee63649b8f26cf999ca4c511a19f3d0a2774e32f4af"

  url "https:github.comimolorhealtairreleasesdownloadv#{version}altair_#{version}_#{arch}_mac.zip",
      verified: "github.comimolorhealtair"
  name "Altair GraphQL Client"
  desc "GraphQL client"
  homepage "https:altair.sirmuel.design"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "Altair GraphQL Client.app"

  zap trash: [
    "~LibraryApplication Supportaltair",
    "~LibraryPreferencescom.electron.altair.helper.plist",
    "~LibraryPreferencescom.electron.altair.plist",
    "~LibrarySaved Application Statecom.electron.altair.savedState",
  ]
end