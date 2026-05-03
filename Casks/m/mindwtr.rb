cask "mindwtr" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.9"
  sha256 arm:   "70b732ccbd18d3f29ec7af321a477b37119479c8cda5873254a4a27cf20a34b2",
         intel: "27e7ae2f322fb3ea9b2ccc365b25125be446eeacf44a232b9129edacf51b2647"

  url "https://ghfast.top/https://github.com/dongdongbh/Mindwtr/releases/download/v#{version}/mindwtr_#{version}_#{arch}.dmg"
  name "Mindwtr"
  desc "Local-first GTD productivity tool"
  homepage "https://github.com/dongdongbh/Mindwtr"

  depends_on :macos

  app "Mindwtr.app"

  zap trash: [
    "~/Library/Application Support/mindwtr",
    "~/Library/Application Support/tech.dongdongbh.mindwtr",
    "~/Library/Preferences/tech.dongdongbh.mindwtr.plist",
    "~/Library/Saved Application State/tech.dongdongbh.mindwtr.savedState",
  ]
end