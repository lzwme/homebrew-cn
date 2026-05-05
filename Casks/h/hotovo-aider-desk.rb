cask "hotovo-aider-desk" do
  arch arm: "arm64", intel: "x64"

  version "0.64.0"
  sha256 arm:   "b60a429cf722a8bb811ad40d1e537f3ce8d3de15528508375bfd6c1f87361cef",
         intel: "339266ec288a7e9115cab0ad88a9447f073e4e8e99cd734e09406440ea801767"

  url "https://ghfast.top/https://github.com/hotovo/aider-desk/releases/download/v#{version}/aider-desk-#{version}-macos-#{arch}.dmg"
  name "AiderDesk"
  desc "Desktop GUI for Aider AI pair programming"
  homepage "https://github.com/hotovo/aider-desk"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "aider-desk.app"

  zap trash: [
    "~/Library/Application Support/aider-desk",
    "~/Library/Logs/aider-desk",
    "~/Library/Preferences/com.hotovo.aider-desk.plist",
    "~/Library/Saved Application State/com.hotovo.aider-desk.savedState",
  ]
end