cask "epic-games" do
  version "17.2.0"
  sha256 "25b3bdaaf3d6a83b5595c67529d494d23db058dd0ecedec87234cd91d329500e"

  url "https://epicgames-download1.akamaized.net/Builds/UnrealEngineLauncher/Installers/Mac/EpicInstaller-#{version}.dmg",
      verified: "epicgames-download1.akamaized.net/"
  name "Epic Games Launcher"
  desc "Launcher for *Epic Games* games"
  homepage "https://www.epicgames.com/"

  livecheck do
    url "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncher.dmg"
    strategy :header_match
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Epic Games Launcher.app"

  zap trash: [
    "~/Library/Application Support/Epic",
    "~/Library/Caches/com.epicgames.EpicGamesLauncher",
    "~/Library/Cookies/com.epicgames.EpicGamesLauncher.binarycookies",
    "~/Library/HTTPStorages/com.epicgames.CrashReportClient",
    "~/Library/HTTPStorages/com.epicgames.EpicGamesLauncher",
    "~/Library/Logs/Unreal Engine/EpicGamesLauncher",
    "~/Library/Preferences/Unreal Engine/EpicGamesLauncher",
  ]

  caveats do
    requires_rosetta
  end
end