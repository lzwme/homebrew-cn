class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.55.1.tgz"
  sha256 "fa0523dc13c5026c6a91e35c60b83527589702311d5a9072a97e08c727383661"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f1c935fa039854638e9f708258c33e6dd412c22706b2248d451154a0289b3dd"
    sha256 cellar: :any,                 arm64_sequoia: "233842a5fe8267c49fa3023b7eb90476d572ed3082d27e2fc58ed339503c9e73"
    sha256 cellar: :any,                 arm64_sonoma:  "233842a5fe8267c49fa3023b7eb90476d572ed3082d27e2fc58ed339503c9e73"
    sha256 cellar: :any,                 sonoma:        "02fd7512b6fa60a5216bf2a7f7d211c64fc4e2d3b359b868e3e14e67f7a03df6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca12c3915ba6381fe3fa796e33d56f71113ddfbdcb7eeb174107edba385e543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1cae3dbc398da0e30cb49a95eb71d29cbd0ee2c3fcb9044731e762b70a33f17"
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
    assert_match version.to_s, shell_output("#{bin}/pi --version")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end