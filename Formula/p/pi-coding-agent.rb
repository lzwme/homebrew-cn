class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.99.2.tgz"
  sha256 "5bb197bed8e46b5352a7a940ddc868c358725b214f27f3ad4d33e77ee9832558"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1502e24cb28dd8df15bacfa95675ffe63978bd61779279f68ec7fcd97693283f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1502e24cb28dd8df15bacfa95675ffe63978bd61779279f68ec7fcd97693283f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1502e24cb28dd8df15bacfa95675ffe63978bd61779279f68ec7fcd97693283f"
    sha256 cellar: :any,                 arm64_linux:       "953de8e0ac37d465fa034129767d2204798f6680744b3925b309ca428d69860d"
    sha256 cellar: :any,                 x86_64_linux:      "2ec84660f0c30213c8b88619939106391b86f40423fc43f8846b1c2d747003da"
  end

  depends_on "node"

  on_linux do
    depends_on "libxcb"
  end

  def install
    system "npm", "install", *std_npm_args
    (bin/"pi").write_env_script libexec/"bin/pi", PI_SKIP_VERSION_CHECK: "1"

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end

    # Rebuild the X11 clipboard helper against our `libxcb`
    system "bash", node_modules/"@earendil-works/pi-tui/native/linux/build.sh" if OS.linux?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end