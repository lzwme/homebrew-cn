cask "scatter" do
  version "12.1.1"
  sha256 "b7db4b8bb63547e4313520fa906e149646ee4f7344d916921af5c57dc885ebc2"

  url "https:github.comGetScatterScatterDesktopreleasesdownload#{version}mac-scatter-#{version}.dmg",
      verified: "github.comGetScatterScatterDesktop"
  name "Scatter"
  desc "Desktop wallet for EOS"
  homepage "https:get-scatter.com"

  app "Scatter.app"

  zap trash: [
    "~LibraryApplication Supportscatter",
    "~LibraryLogsscatter",
    "~LibraryPreferencescom.get-scatter.server.plist",
    "~LibrarySaved Application Statecom.get-scatter.server.savedState",
  ]
end