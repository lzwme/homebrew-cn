cask "moonlight" do
  version "5.0.1"
  sha256 "4dc5e70810dbc3611e6cf5c72d1dbc054668a727c6c1afe4d64c5aff3180544b"

  url "https:github.commoonlight-streammoonlight-qtreleasesdownloadv#{version}Moonlight-#{version}.dmg",
      verified: "github.commoonlight-streammoonlight-qt"
  name "Moonlight"
  desc "GameStream client"
  homepage "https:moonlight-stream.org"

  depends_on macos: ">= :mojave"

  app "Moonlight.app"

  zap trash: [
    "~LibraryCachesMoonlight Game Streaming Project",
    "~LibraryPreferencescom.moonlight-stream.Moonlight.plist",
    "~LibrarySaved Application Statecom.moonlight-stream.Moonlight.savedState",
  ]
end