cask "around" do
  arch arm: "-arm64"

  version "1.2.35"
  sha256 :no_check

  url "https://downloads.around.co/Around#{arch}.dmg"
  name "Around"
  desc "Video calls designed for energy, ideas and action"
  homepage "https://www.around.co/"

  no_autobump! because: :requires_manual_review

  disable! date: "2025-04-20", because: :discontinued

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Around.app"

  uninstall quit: "co.teamport.around"

  zap trash: [
    "~/Library/Application Support/Around",
    "~/Library/Caches/co.around.installer",
    "~/Library/Preferences/co.teamport.around.plist",
    "~/Library/Saved Application State/co.around.installer.savedState",
    "~/Library/Saved Application State/co.teamport.around.savedState",
  ]
end