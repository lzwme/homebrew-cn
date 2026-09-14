cask "diversion" do
  arch arm: "arm64", intel: "amd64"

  version "1.6.122"
  sha256 arm:   "c073137b2b8d0b7de51a5ed5aaf350ac77d9a15091db9e3452e29e8d45274f1c",
         intel: "ca38e08311db72aa7176248d33686a94cec83a7340a48459a7e2a3354e011f68"

  url "https://get.diversion.dev/update/dv/v#{version}/darwin-#{arch}.gz"
  name "Diversion CLI"
  desc "Cloud-native version control CLI and agent"
  homepage "https://www.diversion.dev/"

  livecheck do
    url "https://get.diversion.dev/update/dv/darwin-arm64.json"
    strategy :json do |json|
      json["Version"]&.sub(/^v/, "")
    end
  end

  depends_on :macos

  binary "darwin-#{arch}", target: "dv"

  uninstall launchctl: "diversion.dv.agent"

  zap trash: [
    "~/.diversion",
    "~/Library/Caches/diversion",
    "~/Library/LaunchAgents/diversion.dv.agent.plist",
  ]
end