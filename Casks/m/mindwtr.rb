cask "mindwtr" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.1"
  sha256 arm:   "23cdb268519502fe173511ec86084f727d5c3c1f3500a03585032d175ef04948",
         intel: "bb0402a30103231f226dd9da5a308c085fbca295cc7ba7eb0ccb354aacaa2d37"

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