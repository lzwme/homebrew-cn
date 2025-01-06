cask "macgesture" do
  version "3.2.0"
  sha256 "dd1dafaa4958524f5cf7e3ba35d3235c11f4348d429be63df03a0f6cf8aa0000"

  url "https:github.comMacGestureMacGesturereleasesdownload#{version}MacGesture-#{version}.zip"
  name "MacGesture"
  desc "Utility to set up global mouse gestures"
  homepage "https:github.comMacGestureMacGesture"

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "MacGesture.app"

  zap trash: [
    "~LibraryCachescom.codefalling.MacGesture",
    "~LibraryPreferencescom.codefalling.MacGesture.plist",
    "~LibraryWebKitcom.codefalling.MacGesture",
  ]
end