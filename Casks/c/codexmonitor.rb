cask "codexmonitor" do
  version "0.7.56"
  sha256 "c08136562e69943f9ded7aab18ea6d5cd6a01cdfcb71159e3219e3e2889fb9e0"

  url "https://ghfast.top/https://github.com/Dimillian/CodexMonitor/releases/download/v#{version}/CodexMonitor.app.tar.gz",
      verified: "github.com/Dimillian/CodexMonitor/"
  name "CodexMonitor"
  desc "Monitor Codex activity"
  homepage "https://www.codexmonitor.app/"

  # The upstream release cadence varies but can sometimes involve several per
  # day, so this minimal throttle rate is intended to dampen bursts of releases.
  livecheck do
    url :url
    throttle 2
  end

  auto_updates true
  depends_on arch: :arm64

  app "Codex Monitor.app"

  zap trash: [
    "~/Library/Application Support/com.dimillian.codexmonitor",
    "~/Library/Caches/com.dimillian.codexmonitor*",
    "~/Library/Preferences/com.dimillian.codexmonitor.plist",
  ]
end