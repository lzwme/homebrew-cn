cask "mindwtr" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.20"
  sha256 arm:   "f41d42504f0b0a8998f387a2df62389b34090f1a47a11396e9d67bd3381d46d4",
         intel: "4b3f59a7e937448d5d354a2a0736ac72c32c0d24a2ac97df1de784af873fdfd9"

  url "https://ghfast.top/https://github.com/dongdongbh/Mindwtr/releases/download/v#{version}/mindwtr_#{version}_#{arch}.dmg"
  name "Mindwtr"
  desc "Local-first GTD productivity tool"
  homepage "https://github.com/dongdongbh/Mindwtr"

  app "Mindwtr.app"

  zap trash: [
    "~/Library/Application Support/mindwtr",
    "~/Library/Application Support/tech.dongdongbh.mindwtr",
    "~/Library/Preferences/tech.dongdongbh.mindwtr.plist",
    "~/Library/Saved Application State/tech.dongdongbh.mindwtr.savedState",
  ]
end