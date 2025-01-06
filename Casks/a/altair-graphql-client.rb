cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "8.1.3"
  sha256 arm:   "b5e71d34df33d3b68467bc53efd900bd0715b06c4f93e760ee2ce3590d0f9de5",
         intel: "366e1ffd05ff3d7000a435165b5fb7e19b57a792a5f10e402669bef6d63ce0ef"

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