cask "agent-tars" do
  version "1.0.0-alpha.8"
  sha256 "4e2c8c30740c32196955874b3357a06994863abc33330898e214690a61529132"

  url "https:github.combytedanceUI-TARS-desktopreleasesdownloadAgent-TARS-v#{version}Agent.TARS-#{version}-universal.dmg"
  name "Agent TARS"
  desc "Multimodal AI agent for GUI interaction"
  homepage "https:github.combytedanceUI-TARS-desktop"

  livecheck do
    url :url
    regex(^Agent[._-]TARS[._-]v?(\d+(?:\.\d+)+(?:[._-]alpha[._-]?\d+)?)$i)
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Agent TARS.app"

  uninstall quit: "com.bytedance.agenttars"

  zap trash: [
    "~LibraryApplication Supportagent-tars",
    "~LibraryLogsagent-tars",
  ]
end