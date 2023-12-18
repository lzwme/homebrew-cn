cask "haptickey" do
  version "0.7.0"
  sha256 "f2f2cb1b8bc38cec80d430dabf3c8020c40a54b0380079e83294c62c7c108c53"

  url "https:github.comniwHapticKeyreleasesdownload#{version}HapticKey.app.zip"
  name "HapticKey"
  desc "Trigger haptic feedback when tapping Touch Bar"
  homepage "https:github.comniwHapticKey"

  depends_on macos: ">= :sierra"

  app "HapticKey.app"

  uninstall quit: "at.niw.HapticKey"

  zap trash: [
    "~LibraryCachesat.niw.HapticKey",
    "~LibraryPreferencesat.niw.HapticKey.plist",
  ]
end