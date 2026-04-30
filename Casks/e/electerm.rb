cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "3.7.18"
  sha256 arm:   "910fe9b96671d2b68c7e35ce9a9efef071906d902df39f8fe92a5e35c7263339",
         intel: "e6e3da2bf51f3ae39c26e683f559480b22dfb31cd05fe01c6fa3395d6c4ace8f"

  url "https://ghfast.top/https://github.com/electerm/electerm/releases/download/v#{version}/electerm-#{version}-mac-#{arch}.dmg",
      verified: "github.com/electerm/electerm/"
  name "electerm"
  desc "Terminal/ssh/sftp client"
  homepage "https://electerm.html5beta.com/"

  livecheck do
    url "https://electerm.html5beta.com/data/electerm-github-release.json"
    strategy :json do |json|
      json.dig("release", "tag_name")&.sub("v", "")
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "electerm.app"
  binary "#{appdir}/electerm.app/Contents/MacOS/electerm"

  zap trash: [
    "~/Library/Application Support/electerm",
    "~/Library/Logs/electerm",
    "~/Library/Preferences/org.electerm.electerm.plist",
    "~/Library/Saved Application State/org.electerm.electerm.savedState",
  ]
end