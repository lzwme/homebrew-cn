cask "requestly" do
  arch arm: "-arm64"

  version "26.2.27"
  sha256 arm:   "1cabedff61b95fa287f105769aef75084f155b0f7628924372ebef4f24fffd73",
         intel: "1576c02b3b26ecd36b29e76c812cece30e2d79f0d276ab48e817b9305e60610d"

  url "https://ghfast.top/https://github.com/requestly/requestly-desktop-app/releases/download/v#{version}/Requestly-#{version}#{arch}.dmg",
      verified: "github.com/requestly/requestly-desktop-app/"
  name "Requestly"
  desc "Intercept and modify HTTP requests"
  homepage "https://requestly.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Requestly.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/io.requestly*.sfl*",
    "~/Library/Application Support/Requestly",
    "~/Library/Logs/Requestly",
    "~/Library/Preferences/io.requestly.*.plist",
    "~/Library/Saved Application State/io.requestly.*.savedState",
  ]
end