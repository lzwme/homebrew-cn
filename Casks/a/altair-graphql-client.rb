cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.1.4"
  sha256 arm:   "cf7446c0cbdc192083059d32a66eb95c1daeb432222977968d2a65fba65ed7b0",
         intel: "66d7b40c50ba3d30d53fd8e9388b6ff93a5c1d5fc07d6ff1f93595c9e3a212f6"

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