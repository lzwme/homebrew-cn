class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.70.5.tgz"
  sha256 "0e94f5d8f99b0dc9cb5ad324cb1cfabeb600e44576d0c0d17fcae703a0723115"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f01a70a0c8dd2c4d5ca881e220a78ff30af5fa8a68ccce66c3f6d743bea3fec9"
    sha256 cellar: :any,                 arm64_sequoia: "d871d25eb0dc688ee39cc447164bcd674d1e6f4ddf1538febc90b609343823a0"
    sha256 cellar: :any,                 arm64_sonoma:  "d871d25eb0dc688ee39cc447164bcd674d1e6f4ddf1538febc90b609343823a0"
    sha256 cellar: :any,                 sonoma:        "a3f639ce9cb4f4e4775b29e8c0891b1651b02b6ba6acfb2a18961db23c4f4fd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46156f2d72e2a07f21cb0c70c76b5c4cc77fc10efc2a6cb27b6042f493cd8f54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1fe638eddd29aceec5e5020b5273f6d2cab698e0ec77335274de91060d613e1"
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