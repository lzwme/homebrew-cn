cask "loom" do
  arch arm: "-arm64"

  version "0.346.3"
  sha256 arm:   "50808dcb8284e48da706911c9b1d4ac7e7eb4f4c7bb4cb346f2d12b2bc1daff3",
         intel: "145d726884761264c1d37861bd0b79b202440f067730f07ad6214a785b75ba90"

  url "https://packages.loom.com/desktop-packages/Loom-#{version}#{arch}.dmg"
  name "Loom"
  desc "Screen and video recording software"
  homepage "https://www.loom.com/"

  livecheck do
    url "https://packages.loom.com/desktop-packages/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Loom.app"

  uninstall login_item: "Loom"

  zap trash: [
    "~/Library/Application Support/Loom",
    "~/Library/Logs/Loom",
    "~/Library/Preferences/com.loom.desktop.plist",
    "~/Library/Saved Application State/com.loom.desktop.savedState",
  ]
end