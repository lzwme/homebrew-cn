cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.0.2"
  sha256 arm:   "60488bad6fd92d1400fe84ab5eac0df28f7f43c864044c48c3dc22d58c4fb824",
         intel: "3054cc226caf6965e18d4371e2e8b228b3990d76f3395361f8f6dccd6ec2ca4b"

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