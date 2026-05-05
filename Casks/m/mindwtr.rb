cask "mindwtr" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.0"
  sha256 arm:   "e43899d665f53641e90c1f42f519aac6b1352cbe0a66ebd9dfc8dff35e60f6f8",
         intel: "62ab6e0291d121724ef17197cafbb92e8f076d54170d7a94973ed91e3af4ba46"

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