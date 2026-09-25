class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.87.1.tgz"
  sha256 "1423ee3c61e7c96464e1cbf3c8dc24d3056cb3410995c3671a98c3ecc527540f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a129e43cc116789419424b89bac89ce65299f56012613586ffeb45b676fdb89b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a129e43cc116789419424b89bac89ce65299f56012613586ffeb45b676fdb89b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a129e43cc116789419424b89bac89ce65299f56012613586ffeb45b676fdb89b"
    sha256 cellar: :any,                 arm64_linux:       "33f06b40f37d932c75cf8b2e52adba9940656836b5b877a5104e02aad0cca984"
    sha256 cellar: :any,                 x86_64_linux:      "466219bcc9dd7695988329383fb28eeee484fbf8e2b7515bdbca828e34ce4ac2"
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