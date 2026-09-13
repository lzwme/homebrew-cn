class Summarize < Formula
  desc "Multi-modal AI tool to extract and summarize content"
  homepage "https://summarize.sh"
  url "https://registry.npmjs.org/@steipete/summarize/-/summarize-0.21.14.tgz"
  sha256 "2460472dd40d3652b39952b44b39fa980b74a4fbc5a1c66dbd6b67c7d9e95999"
  license "MIT"
  head "https://github.com/steipete/summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fca3b6e8266266d91fcce23c4ef1822d78ce02a613cf4450b1cd9c4a8c9c6555"
  end

  depends_on "ffmpeg"
  depends_on "node"
  depends_on "tesseract"
  depends_on "yt-dlp"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/summarize --version")

    output = pipe_output("#{bin}/summarize - 2>&1", "Hello from Homebrew test.")
    assert_match "Hello from Homebrew test.", output
  end
end