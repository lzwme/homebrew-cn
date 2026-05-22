class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.75.4.tgz"
  sha256 "d767b574a2824b2cb675e7ba853ed6a3d84dc37e83502be22b14aeb9b818d697"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "52e67fa69d9dd03717c84b69b70b963123516375bdaa5db04b1208f920d63dc6"
    sha256 cellar: :any,                 arm64_sequoia: "383561a461241062805fcb2f8a48a84c819cb177dacac0edba333180af86e424"
    sha256 cellar: :any,                 arm64_sonoma:  "383561a461241062805fcb2f8a48a84c819cb177dacac0edba333180af86e424"
    sha256 cellar: :any,                 sonoma:        "42efea63cdb51168b5a0ed0061253f5f91949452031b1c5af91d9ef96f0b8eab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "761b7761ee4a9e87709d57c448c52f4fee888fffd58656bce02c1b7d86432131"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b9d5300daf752a690655c93e426be3f0af27acb2aa5f8dfef7c31cac14697bf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@earendil-works/pi-coding-agent/node_modules/"
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