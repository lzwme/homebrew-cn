cask "iterm2@beta" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "3.5.1beta4"
  sha256 "71e892c8ee07eb45d3275ece652c358c9318b341cc29e2ac69ab8b8062c6d24a"

  url "https://iterm2.com/downloads/beta/iTerm2-#{version.dots_to_underscores}.zip"
  name "iTerm2"
  desc "Terminal emulator as alternative to Apple's Terminal app"
  homepage "https://iterm2.com/"

  livecheck do
    url "https://iterm2.com/appcasts/testing_modern.xml"
    strategy :sparkle, &:version
  end

  auto_updates true
  conflicts_with cask: [
    "iterm2",
    "iterm2@nightly",
  ]
  depends_on macos: ">= :catalina"

  app "iTerm.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.googlecode.iterm2.sfl*",
    "~/Library/Application Support/iTerm",
    "~/Library/Application Support/iTerm2",
    "~/Library/Caches/com.googlecode.iterm2",
    "~/Library/Preferences/com.googlecode.iterm2.plist",
    "~/Library/Saved Application State/com.googlecode.iterm2.savedState",
  ]
end