class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.99.1.tgz"
  sha256 "6686592adaea19092c85c94f5d40323dbf3db141e90eb3ede9e9e87302abdd1d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "93a658e1b428f8db35af513a6bf3505b4daba9cedebb72d669982787393fc68b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93a658e1b428f8db35af513a6bf3505b4daba9cedebb72d669982787393fc68b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93a658e1b428f8db35af513a6bf3505b4daba9cedebb72d669982787393fc68b"
    sha256 cellar: :any,                 arm64_linux:       "9d6341c59e2de2caed05af0372a85b5f0717f797f0c129d4a71ec3d702ce2736"
    sha256 cellar: :any,                 x86_64_linux:      "7daba5463d814c5843b76cfae51576f9d35a67aacbbec30efcef53a8a5ff1b36"
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