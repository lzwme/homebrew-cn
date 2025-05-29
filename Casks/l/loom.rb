cask "loom" do
  arch arm: "-arm64"

  version "0.293.8"
  sha256 arm:   "3edfe0f116801d9a1ab266703d6bfb6546c25b56dd97e8088d4ae89899b59498",
         intel: "e53269d7aadf972bfacf0bd98faafea8fb3df430cf3d786ea68bf2085de68143"

  url "https://packages.loom.com/desktop-packages/Loom-#{version}#{arch}.dmg"
  name "Loom"
  desc "Screen and video recording software"
  homepage "https://www.loom.com/"

  livecheck do
    url "https://packages.loom.com/desktop-packages/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Loom.app"

  uninstall login_item: "Loom"

  zap trash: [
    "~/Library/Application Support/Loom",
    "~/Library/Logs/Loom",
    "~/Library/Preferences/com.loom.desktop.plist",
    "~/Library/Saved Application State/com.loom.desktop.savedState",
  ]
end