cask "alma" do
  arch arm: "arm64", intel: "x64"

  version "0.0.615"
  sha256 arm:   "3db5690c2e1a7c76fc9fdd51cc6a1f8984188083d0e6c87297152a7a7cab96fa",
         intel: "25f2c98cebbd361e477579fb6859161df5b3a753cd22c4b6af79261f94e89713"

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