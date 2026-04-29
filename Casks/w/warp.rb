cask "warp" do
  version "0.2026.04.27.15.32.stable_02"
  sha256 "ae4db0204568a853caad1d8ecd8a2d85f299b05635e34ce88112b4309490f106"

  url "https://app.warp.dev/download/brew?version=v#{version}"
  name "Warp"
  desc "Rust-based terminal"
  homepage "https://www.warp.dev/"

  livecheck do
    url "https://releases.warp.dev/channel_versions.json"
    strategy :json do |json|
      json.dig("stable", "version")&.delete_prefix("v")
    end
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Warp.app"

  zap trash: [
    "~/.warp",
    "~/Library/Application Support/dev.warp.Warp-Stable",
    "~/Library/Logs/warp.log*",
    "~/Library/Preferences/dev.warp.Warp-Stable.plist",
    "~/Library/Saved Application State/dev.warp.Warp-Stable.savedState",
  ]
end