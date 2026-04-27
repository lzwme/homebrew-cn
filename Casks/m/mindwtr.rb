cask "mindwtr" do
  arch arm: "aarch64", intel: "x64"

  version "0.8.8"
  sha256 arm:   "786c7916f60c7ef6e9391345ede2c1a5923cf6ecf114aa5ef6406df84678e5ec",
         intel: "82bd6e14529b0b12e62f7d55ea97e1a0f4ddec3fa57bab7af7e7b9872b932dd7"

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