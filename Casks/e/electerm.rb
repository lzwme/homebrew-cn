cask "electerm" do
  arch arm: "arm64", intel: "x64"

  version "1.37.16"
  sha256 arm:   "9e8896128a486fa6ec19610904ea210edd24fa54c82a15ac6353575e34d39bec",
         intel: "35c5eb1ac36d8aeca4f7ff7b5a1775d0996bfa5f418a88f84df6f94621ebdbe6"

  url "https://ghproxy.com/https://github.com/electerm/electerm/releases/download/v#{version}/electerm-#{version}-mac-#{arch}.dmg"
  name "electerm"
  desc "Terminal/ssh/sftp client"
  homepage "https://github.com/electerm/electerm/"

  auto_updates true

  app "electerm.app"
  binary "#{appdir}/electerm.app/Contents/MacOS/electerm"

  zap trash: [
    "~/Library/Application Support/electerm",
    "~/Library/Logs/electerm",
    "~/Library/Preferences/org.electerm.electerm.plist",
    "~/Library/Saved Application State/org.electerm.electerm.savedState",
  ]
end