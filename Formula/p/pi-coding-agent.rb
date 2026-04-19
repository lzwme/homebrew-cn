class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.67.68.tgz"
  sha256 "0b64fe21e2221e15c0cb94c9dffd5cfbb9901ae99df416a71c5d915a6e9e1717"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2bd3b9e387cebcd7014f937b6b017d544bdae377f76de274f32a582cb74a3515"
    sha256 cellar: :any,                 arm64_sequoia: "97ffe39fb5ef1aa4e171baec3fe6a583fdbb8441c4c10e3baa9b82254dc8828d"
    sha256 cellar: :any,                 arm64_sonoma:  "97ffe39fb5ef1aa4e171baec3fe6a583fdbb8441c4c10e3baa9b82254dc8828d"
    sha256 cellar: :any,                 sonoma:        "6a87c70ece7de3f70f2369e0b28735c4fb317990cbb88a895dfa048abde47622"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f28dac3064f0c2bb54c32e240bdd8f4acd41a58b7230905fea7473ce1d48b385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a500bc9b3e88862336fcdea4abfe8b833d19fd6091ebff2566b006e02f4192"
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