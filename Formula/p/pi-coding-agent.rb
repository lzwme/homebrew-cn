class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.0.0.tgz"
  sha256 "638ed3abbe54ef70cbf8673ae4bc531e791613756aac04644cfcdcc4af0fafaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "46ef7733127b2e32b17229747b568e9825b0a84118848d2dcad3398bd2b8bae5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "46ef7733127b2e32b17229747b568e9825b0a84118848d2dcad3398bd2b8bae5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "46ef7733127b2e32b17229747b568e9825b0a84118848d2dcad3398bd2b8bae5"
    sha256 cellar: :any,                 arm64_linux:       "9aab0fb678d3baed8faff526118fcf23fcdd9e391d288cd1cea05faf06a5680f"
    sha256 cellar: :any,                 x86_64_linux:      "9ad845f156ed22df5f3ccb09f0254a3e7e9195171001ff6b815d216d48f54084"
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