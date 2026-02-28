cask "alma" do
  arch arm: "arm64", intel: "x64"

  version "0.0.645"
  sha256 arm:   "1f781e13c1235ba157d58cb1aff5d4317189694a04a875db91cfcff4aa916ea1",
         intel: "bea9758c5057d1687044163fce75522ca9f4aeb0a5b9c3dc3f79f82fc0b4cf1f"

  url "https://updates.alma.now/alma-#{version}-mac-#{arch}.dmg"
  name "Alma"
  desc "AI chat application"
  homepage "https://alma.now/"

  livecheck do
    url "https://github.com/yetone/alma-releases"
    strategy :github_releases
    throttle 15
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Alma.app"

  uninstall quit: "com.yetone.alma"

  zap trash: [
    "~/.config/alma",
    "~/Library/Application Support/alma",
    "~/Library/Preferences/com.yetone.alma.plist",
  ]
end