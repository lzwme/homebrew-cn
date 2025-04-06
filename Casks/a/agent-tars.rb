cask "agent-tars" do
  version "1.0.0-alpha.7"
  sha256 "50558a6b448409d33603c8ceb1c3bc7a699d07719fabd1a0faa9a087abe16c78"

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