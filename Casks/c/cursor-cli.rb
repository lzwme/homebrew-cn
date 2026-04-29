cask "cursor-cli" do
  arch arm: "arm64", intel: "x64"

  version "2026.04.28-e984b46"
  sha256 arm:   "0c5812948524d3b24eaf47ea1582ed97d1bafebad3d682f47e2f45242d00bead",
         intel: "068fafcaf2412332926e94f66b696bc0a41b591e8c6ba55dd489541d834baff8"

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