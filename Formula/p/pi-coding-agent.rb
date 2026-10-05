class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-1.0.2.tgz"
  sha256 "eda5ae7875343bd902ffe55718fb65b2406d7b03abecc5cb89d8e4bb09ceeda2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6170ac71f0ac5945dbc3ba0ee8d9107413f54737f28eff0f277a90a07e09161f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6170ac71f0ac5945dbc3ba0ee8d9107413f54737f28eff0f277a90a07e09161f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6170ac71f0ac5945dbc3ba0ee8d9107413f54737f28eff0f277a90a07e09161f"
    sha256 cellar: :any,                 arm64_linux:       "05ec216cf23a21be99fa0804ca0eaf42c8c17fc576dae9e53d945963674230c4"
    sha256 cellar: :any,                 x86_64_linux:      "c1bfc530687ed69b9f9de668da4769c982f992777b83c20167b8f3f29e67d1c2"
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