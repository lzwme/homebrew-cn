class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.1.0.tgz"
  sha256 "09cd8a0a43dbb1d81a67346b09400b439ce71d818caba4e963ea958846a1aed4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88dca97f8d7a2c2b4e0aaeb2d0ee166613daf05047c3f58d03709079c99cfb0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88dca97f8d7a2c2b4e0aaeb2d0ee166613daf05047c3f58d03709079c99cfb0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "88dca97f8d7a2c2b4e0aaeb2d0ee166613daf05047c3f58d03709079c99cfb0f"
    sha256 cellar: :any,                 arm64_linux:       "df8bb00f495253a7d45292c5be0e8e1c780afcf5f889aa9efc90e513b8983183"
    sha256 cellar: :any,                 x86_64_linux:      "b4fd7723cc5afe68ee85325c4bedcb64f233c454074f6621a73fee2e142c6549"
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