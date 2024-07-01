cask "moonlight" do
  version "6.0.1"
  sha256 "39996bd3b719d5484fae778916080f2d666bda5dc9067f14f072c72775dc7f61"

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