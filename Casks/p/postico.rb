cask "postico" do
  version "2.2,9742"
  sha256 "aab70a8206c03cab8d7c69279c02543c9702fee23905da97cbfea35378f5edc2"

  url "https://downloads.eggerapps.at/postico/postico-#{version.csv.second}.dmg"
  name "Postico"
  desc "GUI client for PostgreSQL databases"
  homepage "https://eggerapps.at/postico#{version.major}/"

  livecheck do
    url "https://releases.eggerapps.at/postico#{version.major}/appcast.xml?update_channel=2"
    strategy :sparkle
  end

  auto_updates true
  conflicts_with cask: "postico@1"
  depends_on macos: ">= :catalina"

  app "Postico #{version.major}.app"

  zap trash: [
    "~/Library/Application Scripts/at.eggerapps.Postico",
    "~/Library/Caches/at.eggerapps.Postico",
    "~/Library/Containers/at.eggerapps.Postico",
    "~/Library/Preferences/at.eggerapps.Postico.plist",
    "~/Library/Saved Application State/at.eggerapps.Postico.savedState",
  ]
end