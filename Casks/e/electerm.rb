cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "2.10.26"
  sha256 arm:   "026dcf7ed02d747e9a2abfa74f3dcc9ef545b99b9e08f71be1f6c8be717822f0",
         intel: "a0f4fabfd254e79fb9d1b1eb4d8ee2ac0ad63813094d0ab8c4d944ff8201f83e"

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