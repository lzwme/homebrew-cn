class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.80.3.tgz"
  sha256 "155c5800134cb8df6c47adb3eab56415e8fa7746e0b1cba6687134137c451d90"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b685ecd1f1997a967a420f2d2797568c6ce5ebc2c80723c905e88f4e24175e2"
    sha256 cellar: :any,                 arm64_sequoia: "d31eb5b2b8cb6c915e44a9a06cc7942b91c5405bbf4ba0e309743f956bb432f4"
    sha256 cellar: :any,                 arm64_sonoma:  "d31eb5b2b8cb6c915e44a9a06cc7942b91c5405bbf4ba0e309743f956bb432f4"
    sha256 cellar: :any,                 sonoma:        "981b163deae4e6379bd185d396c86941463cee2e0c929066743c7bd04f720c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3de50852fdca2bd111d470cbc0c025e5ce1e9eaadd2cccc8a1824357a65936c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "752ca0b7260762dee8c7f2d92a2cea6aebf4908ca6b7d19507d034585f14a467"
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