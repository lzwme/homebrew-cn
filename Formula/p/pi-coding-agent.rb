class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.66.0.tgz"
  sha256 "e1cb1fbdafe4fc3f8d640962c806fbc4ca9c063c89865c0b1443bfaf583c01c2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "22fcbedbce1a19ed6ba21d358e74216e01894d4b2dab0970e13a490985827a4b"
    sha256 cellar: :any,                 arm64_sequoia: "94ffb5fc41806f79ab907ab77343d6b0c431bbe3a43a7cb75342f93704da7a0e"
    sha256 cellar: :any,                 arm64_sonoma:  "94ffb5fc41806f79ab907ab77343d6b0c431bbe3a43a7cb75342f93704da7a0e"
    sha256 cellar: :any,                 sonoma:        "4c54a8d2cb98da1753316acd330fbbb3eed5c1549fa8e0617c7e801d446052e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c6e0c598d34547997b92d7d55159e2f90193d04fe21b585e9e81aa5e260f44a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19500680395fa7d987dba36a8e5ec6756df20c97b90f429c6cc49afd27504821"
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