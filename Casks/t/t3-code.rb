cask "t3-code" do
  arch arm: "arm64", intel: "x64"

  version "0.0.22"
  sha256 arm:   "d646a1f45452d4990fb2e81828273f7587c18f39f2262212e7b6b23424f3e871",
         intel: "4cf096f51a3b6b13dd6cb5a73d7c32b4b1109af658893e689f3ae130fb81f1b7"

  url "https://ghfast.top/https://github.com/pingdotgg/t3code/releases/download/v#{version}/T3-Code-#{version}-#{arch}.dmg",
      verified: "github.com/pingdotgg/t3code/"
  name "T3 Code"
  desc "Minimal GUI for AI code agents"
  homepage "https://t3.codes/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "T3 Code (Alpha).app"

  zap trash: [
    "~/.t3/userdata",
    "~/Library/Application Support/T3 Code (Alpha)",
    "~/Library/Caches/com.t3tools.t3code",
    "~/Library/HTTPStorages/com.t3tools.t3code",
    "~/Library/Preferences/com.t3tools.t3code.plist",
    "~/Library/Saved Application State/com.t3tools.t3code.savedState",
  ]
end