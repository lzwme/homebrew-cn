class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.86.1.tgz"
  sha256 "8dff93e6fa03e0d498e72a78d2c7bb5f094f5e06ee268e6abd000ba2984a0b6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "23ca764c920cfd4d344017d443848287c656d70f5f77d4c9276b443db6799b86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23ca764c920cfd4d344017d443848287c656d70f5f77d4c9276b443db6799b86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "23ca764c920cfd4d344017d443848287c656d70f5f77d4c9276b443db6799b86"
    sha256 cellar: :any,                 arm64_linux:       "5b639ec5caf0e77a512e469936a0ce319eda307c9ce216fce6a8cfec27acf8b1"
    sha256 cellar: :any,                 x86_64_linux:      "62e689c5bdd51010fb72f226c8686827d0b2731d8db5f6522f030ae50d9dc2fa"
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