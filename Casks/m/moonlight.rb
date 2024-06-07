cask "moonlight" do
  version "6.0.0"
  sha256 "50ff0d886fcb66b4c76d2d4493e49b0fc8d8104ac98a927e76a262ea5b67fbeb"

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