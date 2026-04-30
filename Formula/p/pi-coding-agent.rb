class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.70.6.tgz"
  sha256 "eb27188c02aa3db5e4cb3c862fe65a24a7d91a66440c9c4d0375ae1a82b8dea7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c7cae8c9be9c7705d6425d193007bb24872d91826c66bca9a7025d3639e43ed"
    sha256 cellar: :any,                 arm64_sequoia: "a793e63c8dafc0abe865862111a6fbfddab8791813518deea00088968de35f1a"
    sha256 cellar: :any,                 arm64_sonoma:  "a793e63c8dafc0abe865862111a6fbfddab8791813518deea00088968de35f1a"
    sha256 cellar: :any,                 sonoma:        "d9dca5a3064fabff1ad04ac2b5b5aad1cabf5dff3748501e595ec3265f82c327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3656d4a81a13cede980d3992085269fe06aba4246ab0e5e9dbc16e00af1acd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cbb3a23115eecf8c332140d8114f88a999d6eee2bd7cc8328184d72b06ebd58"
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
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end