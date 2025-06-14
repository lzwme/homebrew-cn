cask "hotswitch" do
  version "1.21"
  sha256 :no_check

  url "https://oniatsu.github.io/HotSwitch/release/zip/HotSwitch.zip"
  name "HotSwitch"
  desc "Fast window switcher using a 2-stroke hotkey"
  homepage "https://oniatsu.github.io/HotSwitch/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "HotSwitch.app"

  zap trash: "~/Library/Preferences/com.oniatsu.HotSwitch.plist"
end