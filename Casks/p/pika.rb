cask "pika" do
  version "1.0.0"
  sha256 "655de9f3ae65a7ad73a5f518ce1ed3c5173edcc5add349c3278bbf27316c8f74"

  url "https:github.comsuperhighfivespikareleasesdownload#{version}Pika-#{version}.dmg",
      verified: "github.comsuperhighfivespika"
  name "Pika"
  desc "Colour picker for colours onscreen"
  homepage "https:superhighfives.compika"

  livecheck do
    url "https:superhighfives.comreleasespika"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Pika.app"

  zap trash: [
    "~LibraryApplication Scriptscom.superhighfives.Pika-LaunchAtLoginHelper",
    "~LibraryContainerscom.superhighfives.Pika-LaunchAtLoginHelper",
    "~LibraryPreferencescom.superhighfives.Pika.plist",
  ]
end