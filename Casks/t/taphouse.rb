cask "taphouse" do
  version "1.4.8.7"
  sha256 "dd03c46171e2e6856583b850d56f082684b3c5fc5ffb95cf6f699f3d676f7ba9"

  url "https://taphouse.multimodalsolutions.gr/downloads/Taphouse-#{version}.dmg"
  name "Taphouse"
  desc "Native GUI for Homebrew package management"
  homepage "https://taphouse.multimodalsolutions.gr/"

  livecheck do
    url "https://taphouse.multimodalsolutions.gr/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "Taphouse.app"

  zap trash: [
    "~/Library/Application Support/Taphouse",
    "~/Library/Caches/Taphouse",
    "~/Library/Preferences/com.multimodalsolutions.taphouse.plist",
  ]
end