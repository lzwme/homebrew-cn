class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.74.1.tgz"
  sha256 "d4721c52f051683b39f0ed2f266e523e19b1a9269f031954ffd1ed33bad0ea83"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd6f7d953951e2eb33787ee30f5f5c36199e50c127a5f6a2b1c8dfd91c5007af"
    sha256 cellar: :any,                 arm64_sequoia: "da5c71f85cfe63c97d19684710d2b9c5c556eeca2b8e71066948e25c2816c51e"
    sha256 cellar: :any,                 arm64_sonoma:  "da5c71f85cfe63c97d19684710d2b9c5c556eeca2b8e71066948e25c2816c51e"
    sha256 cellar: :any,                 sonoma:        "4686a7362e02d04d58443fdfc6ed43365ae2bbe620200102c903499aedfb6df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ccce9510e342cfc116510b6767589b6c6e65250da1e77cc7fdd7f2fdd09f8b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "731c26cd2c63ef867c4d9af2549bd7b39c616fc5ef6dbc1f17b4f0593d4a09ea"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
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