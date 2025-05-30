cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.2.5"
  sha256 arm:   "f0d61a383730001cf4f3e657b08e7a765f643bdf90a2e7e1ada5af32c57478c0",
         intel: "854a262d6afed12797bae085c21ac64e8d78ebf1b947bbf71a6642578b2a724f"

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