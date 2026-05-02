cask "cursor-cli" do
  arch arm: "arm64", intel: "x64"

  version "2026.05.01-eea359f"
  sha256 arm:   "7501dcaed0296c9fae7ba566c8fd31e08592fe7ec4c3ef6845d01aba72f1fe14",
         intel: "a25c9c747b41b1fa61c467e8662d13014fc593bc1e70b9963ed441a62adc146f"

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