cask "wispr-flow" do
  arch arm: "arm64", intel: "x64"

  on_arm do
    version "1.4.396"
    sha256 "a5a5fd93df36d2b76e686e45faf73b780b470219729a1cd2c8cd3f21b733560b"
  end
  on_intel do
    version "1.4.396"
    sha256 "240fd570caaf270e6db2d63c32daa663f64a0980de47badb17cbd3ce6da4731f"
  end

  url "https://dl.wisprflow.com/wispr-flow/darwin/#{arch}/dmgs/Flow-v#{version}.dmg",
      verified: "dl.wisprflow.com/wispr-flow/"
  name "Wispr Flow"
  desc "Voice-to-text dictation with AI-powered auto-editing"
  homepage "https://wisprflow.ai/"

  livecheck do
    url "https://dl.wisprflow.com/wispr-flow/darwin/#{arch}/RELEASES.json"
    strategy :json do |json|
      json["currentRelease"]
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Wispr Flow.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.electron.wispr-flow.sfl*",
    "~/Library/Application Support/Wispr Flow",
    "~/Library/Caches/com.electron.wispr-flow",
    "~/Library/Caches/com.electron.wispr-flow.accessibility-mac-app",
    "~/Library/Caches/com.electron.wispr-flow.ShipIt",
    "~/Library/Caches/SentryCrash/Wispr Flow",
    "~/Library/HTTPStorages/com.electron.wispr-flow",
    "~/Library/Logs/Wispr Flow",
    "~/Library/Preferences/com.electron.wispr-flow.plist",
  ]
end