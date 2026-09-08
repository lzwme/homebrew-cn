cask "diversion" do
  arch arm: "arm64", intel: "amd64"

  version "1.6.26"
  sha256 arm:   "34d0d0528b57be6c8c466152c93978a830c876739b399373a68c580f7e2fd894",
         intel: "23ee89cb0a9db338d39b8c8d208ed301441a78d31dd4a80fe8f1a52bf8990318"

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