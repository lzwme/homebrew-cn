cask "altair-graphql-client" do
  arch arm: "arm64", intel: "x64"

  version "6.3.0"
  sha256 arm:   "c0a280a6d9acfd0b258c606d56b904383f31ccca96060471cfb73f2d4a920643",
         intel: "e6f5abaf64397daebbd707d1fd487b528cd1994eff3ec09d3111e7f8c5f1af9c"

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