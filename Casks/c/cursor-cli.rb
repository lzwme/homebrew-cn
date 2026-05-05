cask "cursor-cli" do
  arch arm: "arm64", intel: "x64"

  version "2026.05.04-08e5280"
  sha256 arm:   "2ce9c30be92df17921240839feeab42c6ec2b10eb0680af698a4533fc154d11f",
         intel: "8a486fd402695df12c7e2a08946c27345c15686689db02d12d95d4cff61fbfd7"

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