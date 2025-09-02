cask "voicenotes" do
  arch arm: "-arm64"

  version "1.3.26"
  sha256 arm:   "49ff24669079bfae1a2a0697828cb2828c1e294a0ed479e9696143f20f2728d5",
         intel: "9e13d36ef9f6c4ad1072d2c72d74a19fbf05912d4a0d77ae3db61ac233c48e5a"

  url "https://ghfast.top/https://github.com/brewdotcom/vn-apps-release/releases/download/#{version}/Voicenotes-#{version}#{arch}.dmg",
      verified: "github.com/brewdotcom/vn-apps-release/"
  name "Voicenotes"
  desc "AI-powered app for recording, transcribing and summarising voice notes"
  homepage "https://voicenotes.com/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "Voicenotes.app"

  zap trash: [
    "~/Library/Application Support/Voicenotes",
    "~/Library/Preferences/com.voicenotes.app.plist",
  ]
end