class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.56.3.tgz"
  sha256 "edc936c3fc7e97d6725b93a5811ee4c0771effdefa88c665ba4c4b6e024d8e5c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f110ec3e6f6cb8ebc726afe64145e45adfc1253996897014468859355bedf874"
    sha256 cellar: :any,                 arm64_sequoia: "49892dd3e41e817a7bbfc41ee4901ba5b999521502e486e5fec92e29b30098af"
    sha256 cellar: :any,                 arm64_sonoma:  "49892dd3e41e817a7bbfc41ee4901ba5b999521502e486e5fec92e29b30098af"
    sha256 cellar: :any,                 sonoma:        "4d2736ce7d32f6d640da2dac167576f20c056bfab2c5b83fb3f883e251a9b83c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7199f2872632771a9b94cd3b8a74b96b7ef6536fcbc0038e89ac3c347226736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80387771d3e703bedf3cfcccaedaefa78735ea686217cfc0f4f0c50cc082873"
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