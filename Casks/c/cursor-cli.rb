cask "cursor-cli" do
  arch arm: "arm64", intel: "x64"

  version "2026.05.05-84a231c"
  sha256 arm:   "4eca189a54dd8e410ae622b908b193b8f11ac96a04172a9899fee4b06378293d",
         intel: "3fe9d18eb5e5b0a06838e2477e30863999dc1b1b33b8b91a5c12160126f32ee8"

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