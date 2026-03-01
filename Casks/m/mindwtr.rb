cask "mindwtr" do
  arch arm: "aarch64", intel: "x64"

  version "0.7.0"
  sha256 arm:   "c789b0b30d86b0975729fdd8e1a9e40babfa712aebd6a0e21a17427719fbe18e",
         intel: "e7007d5424338790c296e24d682fa099c455c1f58803ac24a77db0a27980ff81"

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