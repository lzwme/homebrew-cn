cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "7.2.3"
  sha256 arm:   "e8662177a871a41594dccfacf1bc1155f535dcf9078108a6847dc5e22a69fb70",
         intel: "6f6bef3de55f0859dfcca4bc00f6b5fd37a31320b077f62975fc994f5db89cf7"

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