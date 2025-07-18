cask "omnidisksweeper" do
  on_catalina :or_older do
    on_sierra do
      version "1.10"
      sha256 "0d8f5b7ff075fca4503a41e1ea898a145001f3f602f6b53ffb310e0a465af080"

      url "https://downloads.omnigroup.com/software/MacOSX/10.12/OmniDiskSweeper-#{version}.dmg"
    end
    on_high_sierra do
      version "1.11"
      sha256 "f06b150239e5c5ee27615b1e8bd6ec2c87c61c4cda575547f124ff84986b6f37"

      url "https://downloads.omnigroup.com/software/MacOSX/10.13/OmniDiskSweeper-#{version}(n).dmg"
    end
    on_mojave do
      version "1.13"
      sha256 "bf572a47079cd4dea44f7ae2f14bb9a75e2548ad6066757d33564c21a0003821"

      url "https://downloads.omnigroup.com/software/MacOSX/10.14/OmniDiskSweeper-#{version}.dmg"
    end
    on_catalina do
      version "1.13"
      sha256 "bf572a47079cd4dea44f7ae2f14bb9a75e2548ad6066757d33564c21a0003821"

      url "https://downloads.omnigroup.com/software/MacOSX/10.14/OmniDiskSweeper-#{version}.dmg"
    end

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "1.15.1b"
    sha256 "e079d644e8c0d64a4926d4b426bb0e4932a1b25707901a07c3a227cfdf7574f0"

    url "https://downloads.omnigroup.com/software/macOS/11/OmniDiskSweeper-#{version}.dmg"

    livecheck do
      url "https://update.omnigroup.com/appcast/com.omnigroup.OmniDiskSweeper"
      regex(/OmniDiskSweeper[._-]v?(\d+(?:\.\d+)+[a-z]?)\.dmg/i)
      strategy :sparkle do |item, regex|
        item.url[regex, 1]
      end
    end
  end

  name "OmniDiskSweeper"
  desc "Finds large, unwanted files and deletes them"
  homepage "https://www.omnigroup.com/more/"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :sierra"

  app "OmniDiskSweeper.app"

  zap trash: [
    "~/Library/Application Scripts/com.omnigroup.OmniSoftwareUpdate.OSUCheckService",
    "~/Library/Caches/com.apple.helpd/Generated/OmniDiskSweeper Help*",
    "~/Library/Caches/com.omnigroup.OmniDiskSweeper",
    "~/Library/Containers/com.omnigroup.OmniSoftwareUpdate.OSUCheckService",
    "~/Library/Preferences/com.omnigroup.OmniDiskSweeper.plist",
    "~/Library/Preferences/com.omnigroup.OmniSoftwareUpdate.plist",
  ]
end