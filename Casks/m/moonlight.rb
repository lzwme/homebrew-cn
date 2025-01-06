cask "moonlight" do
  version "6.1.0"
  sha256 "d494740eead8ad4e620cdc8feedb56083bc29cabbbeef34cb82585fd87725fa2"

  url "https:github.commoonlight-streammoonlight-qtreleasesdownloadv#{version}Moonlight-#{version}.dmg",
      verified: "github.commoonlight-streammoonlight-qt"
  name "Moonlight"
  desc "GameStream client"
  homepage "https:moonlight-stream.org"

  depends_on macos: ">= :big_sur"

  app "Moonlight.app"

  zap trash: [
    "~LibraryCachesMoonlight Game Streaming Project",
    "~LibraryPreferencescom.moonlight-stream.Moonlight.plist",
    "~LibrarySaved Application Statecom.moonlight-stream.Moonlight.savedState",
  ]
end