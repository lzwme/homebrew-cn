cask "haptickey" do
  version "0.7.0"
  sha256 "f2f2cb1b8bc38cec80d430dabf3c8020c40a54b0380079e83294c62c7c108c53"

  url "https://ghfast.top/https://github.com/niw/HapticKey/releases/download/#{version}/HapticKey.app.zip"
  name "HapticKey"
  desc "Trigger haptic feedback when tapping Touch Bar"
  homepage "https://github.com/niw/HapticKey"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "HapticKey.app"

  uninstall quit: "at.niw.HapticKey"

  zap trash: [
    "~/Library/Caches/at.niw.HapticKey",
    "~/Library/Preferences/at.niw.HapticKey.plist",
  ]
end