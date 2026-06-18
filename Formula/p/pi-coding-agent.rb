class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.6.tgz"
  sha256 "f5a2941ccea68af49462b22898eaa9968b5c1ec900dbadec08e25b99a9f60bc2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e256cae3f412edd3022f11ba042deb60d7c416d28d27af259fa24889ef80c56b"
    sha256 cellar: :any,                 arm64_sequoia: "7e29d63c7507afad4d210c93e8ea7674ce6458de3e2929cba85c82957197252e"
    sha256 cellar: :any,                 arm64_sonoma:  "7e29d63c7507afad4d210c93e8ea7674ce6458de3e2929cba85c82957197252e"
    sha256 cellar: :any,                 sonoma:        "33b0dc96e0544072ad3af637196c7a95ed3a5b3f79b2fc5fb09f9e9cfe786889"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65dc49b61a68cedfdb4394ea7a036faa39160917ded873a8b40733062dee28f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76f2b53a652930dc68d7778f60de70f0b7273a34c453341fb0a7706161d68336"
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

    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end