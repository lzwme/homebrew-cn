cask "pika" do
  version "1.0.1"
  sha256 "3ea0731188d6eca7e64ca2f59a65cf59189eda2b5e5fcb9ff985012f8cc9c267"

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