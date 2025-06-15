cask "utc-menu-clock" do
  version "1.3"
  sha256 "099a638a7a45cb9085d29e75769caf44ed142fd74b9e4665fca2de7e4a641081"

  url "https:github.comnetikUTCMenuClockrawmasterdownloadsUTCMenuClock_v#{version}_universal.zip"
  name "UTCMenuClock"
  desc "Menu bar clock"
  homepage "https:github.comnetikUTCMenuClock"

  livecheck do
    url "https:github.comnetikUTCMenuClocktreemasterdownloads"
    regex(UTCMenuClock[._-]v?(\d+(?:\.\d+)+)[._-]universal\.zipi)
    strategy :page_match
  end

  no_autobump! because: :requires_manual_review

  app "UTCMenuClock.app"

  zap trash: "~LibraryPreferencesnet.retina.UTCMenuClock.plist"
end