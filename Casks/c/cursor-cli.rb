cask "cursor-cli" do
  arch arm: "arm64", intel: "x64"

  version "2026.05.07-42ddaca"
  sha256 arm:   "6f558bf1444bfb1b558f13ad248d56de00168778b770837df1fdda7835f92653",
         intel: "4c8ef8831435560ad298cbd45d7c1342fea2c6500b9daad8ba5f4346b53602b7"

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