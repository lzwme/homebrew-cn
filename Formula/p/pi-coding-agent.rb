class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.57.1.tgz"
  sha256 "8648e71d5553388ed710f1ef4165d9f090e1783e446629410c545875ac564b6f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2881ab448a0a0db87279c4373acdcdbcd5715007a9f617320c7e37780b9c609e"
    sha256 cellar: :any,                 arm64_sequoia: "5f01d5bac6bff0fc7676b0e67bacbbb9d0a9c5e992c1a26474895e8b603161bf"
    sha256 cellar: :any,                 arm64_sonoma:  "5f01d5bac6bff0fc7676b0e67bacbbb9d0a9c5e992c1a26474895e8b603161bf"
    sha256 cellar: :any,                 sonoma:        "166dda291bb9a729e10b00f5392ad00cfe8b8927078ec43f13f39dc12ab617f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc2bf2982cadeb071a7549ed28e7d72c9834534dab9fef5366dd734a6c951a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "57fae502a86023aa61f27db5761badc6b9d507926353760121d938c1ece50877"
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