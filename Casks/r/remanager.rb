cask "remanager" do
  version "1.4.0"
  sha256 "6394a65adfee7e742d485164da0f7a40616ec559e5368708cede10932f0d8b40"

  url "https://ghfast.top/https://github.com/rmitchellscott/reManager/releases/download/v#{version}/reManager-macos-universal.zip"
  name "reManager"
  desc "Desktop app for managing mods on reMarkable tablets"
  homepage "https://github.com/rmitchellscott/reManager"

  depends_on :macos

  app "reManager.app"

  zap trash: [
    "~/Library/Application Support/reManager",
    "~/Library/Caches/com.wails.reManager",
    "~/Library/Preferences/com.wails.reManager.plist",
  ]
end