class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.67.6.tgz"
  sha256 "22eb780670f1dcecddad2a407f620f5b8a21dbff7d087c581093153e279ebb74"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "638cb4c02b427592ed00b9e223ac3c62a83d8760714fa3d47f2d7e9f7ec75104"
    sha256 cellar: :any,                 arm64_sequoia: "2637cb968d6f8b3037252207625e7491312f5573c57a84c2e9251db82e5097ea"
    sha256 cellar: :any,                 arm64_sonoma:  "2637cb968d6f8b3037252207625e7491312f5573c57a84c2e9251db82e5097ea"
    sha256 cellar: :any,                 sonoma:        "fd0c4a6068b63bfa38fd625de20401c77db462dae3c1abffaaa22e699917f73a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e421a03e82de081ab3336b8133617fefca6a5c0d2d18e80cf5f71fefefdca3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7b0d8f0a82b00f775dfcb88b79cd4e84f0a749d7decb6e7f57ab078c95770db"
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