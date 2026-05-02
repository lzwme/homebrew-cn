cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "3.8.8"
  sha256 arm:   "7df4f3f17fea3b23ff6432027edbe0d4c4978b37227fdaed2beb1c6cec338f37",
         intel: "74f86faea47a020577c9f3be46bc95684b1fb0a5c8425ce4c3ade52f0668101a"

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