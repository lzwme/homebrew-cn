cask "cursor-cli" do
  arch arm: "arm64", intel: "x64"

  version "2026.04.30-4edb302"
  sha256 arm:   "5678213a49dd001f089e996e24f3cb95cf94182c87e33f9cc6ded32d3d02e8a8",
         intel: "3fe78016ae4b04e87e197e095dcea99d70f6b2830251dc3f04c184fea60d771e"

  url "https://downloads.cursor.com/lab/#{version}/darwin/#{arch}/agent-cli-package.tar.gz"
  name "Cursor CLI"
  desc "Command-line agent for Cursor"
  homepage "https://cursor.com/"

  livecheck do
    url "https://cursor.com/install"
    regex(%r{downloads\.cursor\.com/lab/v?(\d+(?:\.\d+)+(?:[._-]\h+)?)/}i)
  end

  depends_on :macos

  binary "#{staged_path}/dist-package/cursor-agent", target: "cursor-agent"

  zap trash: [
    "~/.config/cursor-agent",
    "~/.local/share/cursor-agent",
    "~/Library/Logs/CursorAgent",
  ]
end