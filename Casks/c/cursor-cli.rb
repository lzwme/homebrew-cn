cask "cursor-cli" do
  arch arm: "arm64", intel: "x64"

  version "2026.04.29-c83a488"
  sha256 arm:   "610d66bdb7cffce8dcbdf492aa142b6994243437a7ed8fcd3467727c42aa6157",
         intel: "e0995a66be8ac470d6b0f03a29c3a58aebf43860e837b198ad472c812fc22ad6"

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