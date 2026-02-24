cask "alma" do
  arch arm: "arm64", intel: "x64"

  version "0.0.630"
  sha256 arm:   "1a673cc6ab9c6ce3766376c782d7bcef6a7017c83a2fa946f47ab1c2c416dce9",
         intel: "03e7a0406498d124fa913d1c384c17a10d9a2edc332f8499d3f25db6401ac3e4"

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