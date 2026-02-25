cask "siyuan" do
  arch arm: "-arm64"

  version "3.5.8"
  sha256 arm:   "5f5f512ae5d38071c56222aeff05baf14e3abc72fb7cd73c75a3fc377c4145b9",
         intel: "fd5e961c280e3e1692a39daec4bdd52a9ffa62ed2d4fc2fdc1c65d20b79f496e"

  url "https://ghfast.top/https://github.com/siyuan-note/siyuan/releases/download/v#{version}/siyuan-#{version}-mac#{arch}.dmg"
  name "SiYuan"
  desc "Local-first personal knowledge management system"
  homepage "https://github.com/siyuan-note/siyuan"

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "SiYuan.app"

  zap trash: [
    "~/.siyuan",
    "~/Library/Application Support/SiYuan",
    "~/Library/Preferences/org.b3log.siyuan.plist",
    "~/Library/Saved Application State/org.b3log.siyuan.savedState",
  ]
end