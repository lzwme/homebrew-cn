cask "pika" do
  version "0.0.18"
  sha256 "bf4a41680b75dae005b687482f1a327e043d6d4600a5651dc51fafb4c429a369"

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