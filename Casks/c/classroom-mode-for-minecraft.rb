cask "classroom-mode-for-minecraft" do
  version "1.83"
  sha256 "5eaf55eb603229f003c02a4addde4e50eb5665d8c02de098d4586bf5f04e4ef0"

  url "https://downloads.minecrafteduservices.com/retailbuilds/ClassroomMode/mac/Classroom_Mode_#{version.dots_to_underscores}.dmg",
      verified: "downloads.minecrafteduservices.com/"
  name "Classroom Mode for Minecraft"
  desc "Classroom management app for Minecraft Education Edition"
  homepage "https://education.minecraft.net/"

  livecheck do
    url "https://aka.ms/meecmmacos"
    strategy :header_match
  end

  app "Classroom Mode for Minecraft.app"

  zap trash: [
    "~/Library/Caches/com.microsoft.mc-classroommode",
    "~/Library/WebKit/com.microsoft.mc-classroommode",
  ]

  caveats do
    requires_rosetta
  end
end