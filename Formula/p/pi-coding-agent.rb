class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.69.0.tgz"
  sha256 "6fed51962efb57f751aa054037bfaaaaa379ecffcc517c4ce16c77e590035345"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "71bb1787e34b1b1dcab39f408b36adf8f17953abb34d2f5ed985518363f54237"
    sha256 cellar: :any,                 arm64_sequoia: "b6d265724ad8a9fdc65e5a45c791481f2c66c0c756912ad6f6a8c640113d079d"
    sha256 cellar: :any,                 arm64_sonoma:  "b6d265724ad8a9fdc65e5a45c791481f2c66c0c756912ad6f6a8c640113d079d"
    sha256 cellar: :any,                 sonoma:        "401ad9d6e0110ad92fdfcd6fc3895c54532c6363b1d5df5bb1c400d305014006"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daced1ccc0084b4b5a1840649ab70af9cd75b98ba8bae634cf7e3cc6acf4f02e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8566236d9288cf3b4584e53eb1c3162be759d29057ce7ded3f5fc2a1e0dbc424"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mariozechner/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end