class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.4.tgz"
  sha256 "ca036c23f88fd281b98e0cf0efd01e9c6031de46040b56d58cb047479367bd8c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1e6fd5041ca2e82578babbacb72d18b493f6e61bd3c5d61abc048cb97d877597"
    sha256 cellar: :any,                 arm64_sequoia: "d0bc02cb0f22c98aeba634aebc55da33c42c831355af4a4e4fd55e59c74ebd57"
    sha256 cellar: :any,                 arm64_sonoma:  "d0bc02cb0f22c98aeba634aebc55da33c42c831355af4a4e4fd55e59c74ebd57"
    sha256 cellar: :any,                 sonoma:        "618bcfed592ce5b351445539be66a56fa69ba4990e8c6cc7a1551fa274a29ed0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "445913ba48568e3e624d98a2bab87585de3824b78feb787968ad5a9d953537b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bec4b0624d02bccb4e77b8c9eab0fbaed079f0dd9014fe3fad1a5c12e94f3f4"
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