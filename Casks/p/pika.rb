cask "pika" do
  version "0.0.16"
  sha256 "ce0fe7a8c2fa3a0342588353a83c99a8e38b8d1c15f101615be1a39aae680475"

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