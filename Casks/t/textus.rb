cask "textus" do
  arch arm: "aarch64", intel: "x64"

  version "1.4.2"
  sha256 arm:   "5c54f7ac512b6e9a4a2e4325ac45d24494bf6ee1583f43d8c3d9c207c882bd16",
         intel: "3dc1b2187088a1c8e1498497e08077bdf5b9a58d71430c49cd13689ba4906f7d"

  url "https://ghfast.top/https://github.com/CatVinci-Studio/Textus/releases/download/v#{version}/Textus_#{version}_#{arch}.dmg"
  name "Textus"
  desc "WYSIWYG Markdown editor with built-in AI writing tools"
  homepage "https://textus.catvinci.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on :macos

  app "Textus.app"

  zap trash: [
    "~/Library/Application Support/com.catvinci.textus",
    "~/Library/Caches/com.catvinci.textus",
    "~/Library/Preferences/com.catvinci.textus.plist",
    "~/Library/Saved Application State/com.catvinci.textus.savedState",
    "~/Library/WebKit/com.catvinci.textus",
  ]
end