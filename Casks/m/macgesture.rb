cask "macgesture" do
  version "3.2.0"
  sha256 "dd1dafaa4958524f5cf7e3ba35d3235c11f4348d429be63df03a0f6cf8aa0000"

  url "https://ghfast.top/https://github.com/MacGesture/MacGesture/releases/download/#{version}/MacGesture-#{version}.zip"
  name "MacGesture"
  desc "Utility to set up global mouse gestures"
  homepage "https://github.com/MacGesture/MacGesture"

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "MacGesture.app"

  zap trash: [
    "~/Library/Caches/com.codefalling.MacGesture",
    "~/Library/Preferences/com.codefalling.MacGesture.plist",
    "~/Library/WebKit/com.codefalling.MacGesture",
  ]
end