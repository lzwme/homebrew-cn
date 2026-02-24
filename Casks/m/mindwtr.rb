cask "mindwtr" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.21"
  sha256 arm:   "380ab72b94c6bfcbc854cbd10fdd62485167b531605d654fb190645226a1d867",
         intel: "33937a8dd774aac010940b3ccf457d6dc6c5c92ba78b9439913645f8b894faf8"

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