cask "mindwtr" do
  arch arm: "aarch64", intel: "x64"

  version "0.6.22"
  sha256 arm:   "d4de21325dbe5d30df524cfc25496be15a98d9e8dd2b86482c0268f2f639ae10",
         intel: "e8f07307f1824d2ccb2b32b4b2f1cfefe9cb721ac1c60360c3b8337835860229"

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