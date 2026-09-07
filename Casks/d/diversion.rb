cask "diversion" do
  arch arm: "arm64", intel: "amd64"

  version "1.5.9"
  sha256 arm:   "b5fb703ad25480f1f08d6dbdf71620492abe7d0a1377cdfa5bdcc265ef347c1a",
         intel: "879de5c00c730694da917fd3e21b1b3e8ff45c89c634f80577b9289cc7254d0e"

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

  depends_on macos: :big_sur

  binary "darwin-#{arch}", target: "dv"

  uninstall launchctl: "diversion.dv.agent"

  zap trash: [
    "~/.diversion",
    "~/Library/Caches/diversion",
    "~/Library/LaunchAgents/diversion.dv.agent.plist",
  ]
end