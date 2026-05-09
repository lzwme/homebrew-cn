class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.73.1.tgz"
  sha256 "7bf5d492670c04fd7c599dee7e6eaabff964084affd216766107e6741df7a2e1"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bfe558781c3c4748f1a4c98f8c57ea56f8b0313756c5c17cfb6456287e1120c2"
    sha256 cellar: :any,                 arm64_sequoia: "6b225b1931aa7ec3e06bfd51ecac6ba11897d8930207f57b647183f2072bd134"
    sha256 cellar: :any,                 arm64_sonoma:  "6b225b1931aa7ec3e06bfd51ecac6ba11897d8930207f57b647183f2072bd134"
    sha256 cellar: :any,                 sonoma:        "711fd8196c3150da17c206ab7a11e5f6196b1a3017a1782e56718e3bca9e7a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b5b30618aab244d7382559df69f18c1155200b5844d7c330f8d0c9f30b357b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b26bd56d6b8c00bcfb420829a80ff0020726c5f35ff91f0fa590e5bcf8c1439"
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