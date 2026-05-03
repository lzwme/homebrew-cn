cask "openclaw" do
  version "2026.5.2"
  sha256 "947d3a371326c1ce77181d4ddbc3e3c7ea797033140d8e5ffff6e9d983b6bab7"

  url "https://ghfast.top/https://github.com/openclaw/openclaw/releases/download/v#{version}/OpenClaw-#{version}.dmg",
      verified: "github.com/openclaw/openclaw/"
  name "OpenClaw"
  desc "Personal AI assistant"
  homepage "https://openclaw.ai/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sequoia"

  app "OpenClaw.app"

  zap trash: [
    "~/.openclaw",
    "~/Library/Application Support/OpenClaw",
    "~/Library/HTTPStorages/bot.molt.mac",
    "~/Library/Logs/DiagnosticReports/OpenClaw*",
    "~/Library/Preferences/bot.molt.mac.plist",
    "~/Library/Preferences/bot.molt.shared.plist",
  ]
end