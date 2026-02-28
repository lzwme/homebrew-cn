class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.55.3.tgz"
  sha256 "6e95169013376baf566cedc13d60dbae175f224e09e2663f2587416289252981"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "822bda428401b01a177a1ccec8f5286edd9a1848dffc09d4dd03d830d5c8a3da"
    sha256 cellar: :any,                 arm64_sequoia: "585062a3c83a6ea9ee564984c6746a892b8c716471552d8b3467bc30e1d42a99"
    sha256 cellar: :any,                 arm64_sonoma:  "585062a3c83a6ea9ee564984c6746a892b8c716471552d8b3467bc30e1d42a99"
    sha256 cellar: :any,                 sonoma:        "c16838cd7a79996978935b4091594ab04ba6ccbcb8d3fcd99b25e69f9dc2cceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a49e1e534460f8b31f3aeee891c7a93cbe87a8a63e18ab4f67df4dbbcb554c23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "669e37acd5982b216ea6257f9296935aa7b9ef3067b6f9b65cf4d73ba0bfb181"
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