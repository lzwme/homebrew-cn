class Summarize < Formula
  desc "Multi-modal AI tool to extract and summarize content"
  homepage "https://summarize.sh"
  url "https://registry.npmjs.org/@steipete/summarize/-/summarize-0.24.0.tgz"
  sha256 "75e723e6b5d747f8d553db714c08f87d03ca4a4aae71b79c27903f00cd5b2d87"
  license "MIT"
  head "https://github.com/steipete/summarize.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "801c3fb6989a5f9b7c8b28f03831586732ec83307e0a21a15215bc877ddd8b5b"
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