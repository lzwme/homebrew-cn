cask "grandtotal" do
  version "9.1.5.5"
  sha256 "a5eebb7c80e3bb7951e1963e11318b5340ca7563fa1ab0111115337035d392de"

  url "https://www.mediaatelier.com/GrandTotal#{version.major}/GrandTotal_#{version}.dmg"
  name "GrandTotal"
  desc "Create invoices and estimates"
  homepage "https://www.mediaatelier.com/GrandTotal/"

  livecheck do
    url "https://www.mediaatelier.com/GrandTotal#{version.major}/feed.php"
    regex(/GrandTotal[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
    strategy :sparkle do |items, regex|
      items.map { |item| item.url[regex, 1] }
    end
  end

  auto_updates true
  depends_on macos: ">= :mojave"

  app "GrandTotal.app"

  zap trash: [
    "~/Library/Application Support/com.mediaatelier.GrandTotal*",
    "~/Library/Caches/com.mediaatelier.GrandTotal*",
    "~/Library/HTTPStorages/com.mediaatelier.GrandTotal*",
    "~/Library/Preferences/com.mediaatelier.GrandTotal*.plist",
    "~/Library/Saved Application State/com.mediaatelier.GrandTotal*.savedState",
  ]
end