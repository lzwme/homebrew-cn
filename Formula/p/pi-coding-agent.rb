class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.76.0.tgz"
  sha256 "68c0866fa36c24adc5ceb66506bb3f429cbeccc4cf876d529b5128a07572a3e2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bdb5c47ea5b4819a431d742f3e77a087c9587fb8f63b2ab28d9dad3c29c6f637"
    sha256 cellar: :any,                 arm64_sequoia: "7016b17704d9c671bd5e88406fa5a975ebf79f969319be5d32797afbc0c6f674"
    sha256 cellar: :any,                 arm64_sonoma:  "7016b17704d9c671bd5e88406fa5a975ebf79f969319be5d32797afbc0c6f674"
    sha256 cellar: :any,                 sonoma:        "4b66c44677bc53e5d2d8453fc8b1bf1e1de9e1d57f05f47f0c6251704bcd22e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c6514a2cb9f9076abfacf59101006ec7faaed66fcfc04c71800be6408a25f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4407584dde491958866074bfabd134f0d8b3c6c66d0f47b02aa4545ff2fb8bb"
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