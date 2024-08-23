cask "minecraft" do
  version "1.12.5"
  sha256 :no_check

  url "https://launcher.mojang.com/download/Minecraft.dmg",
      verified: "mojang.com/download/"
  name "Minecraft"
  desc "Sandbox construction video game"
  homepage "https://minecraft.net/"

  livecheck do
    url :url
    strategy :extract_plist
  end

  auto_updates true

  app "Minecraft.app"

  zap trash: [
    "~/Library/Application Support/Minecraft Launcher",
    "~/Library/Caches/com.mojang.minecraftlauncher",
    "~/Library/Caches/com.mojang.minecraftlauncherupdater",
  ]

  caveats do
    requires_rosetta
  end
end