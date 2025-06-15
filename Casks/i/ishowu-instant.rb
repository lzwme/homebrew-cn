cask "ishowu-instant" do
  version "1.4.21"
  sha256 "e6769386a8381aa2a90c189e555de4cbdbdb019e0785542cdb25b32ce58382f3"

  url "https://www.shinywhitebox.com/downloads/instant/iShowU_Instant_#{version}.dmg"
  name "iShowU Instant"
  desc "Realtime screen recording"
  homepage "https://www.shinywhitebox.com/ishowu-instant"

  livecheck do
    url "https://www.shinywhitebox.com/store/appcast.php?p=14"
    strategy :sparkle, &:short_version
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :mojave"

  app "iShowU Instant.app"

  zap trash: [
    "~/Library/Application Support/iShowU Instant",
    "~/Library/Application Support/iShowU Studio",
    "~/Library/Caches/com.shinywhitebox.iShowU-Instant",
    "~/Library/HTTPStorages/com.shinywhitebox.iShowU-Instant",
    "~/Library/HTTPStorages/com.shinywhitebox.iShowU-Instant.binarycookies",
    "~/Library/Preferences/com.shinywhitebox.iShowU-Instant.plist",
    "~/Library/Saved Application State/com.shinywhitebox.iShowU-Instant.savedState",
    "~/Library/WebKit/com.shinywhitebox.iShowU-Instant",
  ]
end