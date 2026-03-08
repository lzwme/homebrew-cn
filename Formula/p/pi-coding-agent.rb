class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.57.0.tgz"
  sha256 "59b27569b6a57b24dccc1863a3de94d906b63d58ed6916cf0fbb435c6e0e333f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa82fe2e777558dd2a17b62fb7f138e68ad00fd3daf302103912400e2c1e850a"
    sha256 cellar: :any,                 arm64_sequoia: "9e4d6fb3615d14973c7703031049a1c28062a909bb34a75e87e31de587f9a71c"
    sha256 cellar: :any,                 arm64_sonoma:  "9e4d6fb3615d14973c7703031049a1c28062a909bb34a75e87e31de587f9a71c"
    sha256 cellar: :any,                 sonoma:        "a03a0b34ba6341f35acaa70dd1204d9ec1b97108fc1f6e42ed0d2abc35ecf507"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49f54c0d79d5cbc04b1940d66c6b4484405656ad834a516c3f8eeaf52684d03c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad461c743ba3a14a73814e59d3afd569755dffdca9e4644d598868c082447335"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@mariozechner/pi-coding-agent/node_modules/"
    deuniversalize_machos node_modules/"@mariozechner/clipboard-darwin-universal/clipboard.darwin-universal.node"

    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    node_modules.glob("koffi/build/koffi/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}_#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end