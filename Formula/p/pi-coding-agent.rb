class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.8.tgz"
  sha256 "494de83a62df3f7a3c3197ba00870890f3bcc3561bbcc9b9d0a9c62dfb4e3e62"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "68a7e039eb4a6445b24c56b6231c92a6810e3419f9335d0b379256d4bbe7bb40"
    sha256 cellar: :any,                 arm64_sequoia: "5af545eb033edb86ddcd2dde512b7dc7ac1c9fbdb23329ea3e52e8db16939f70"
    sha256 cellar: :any,                 arm64_sonoma:  "5af545eb033edb86ddcd2dde512b7dc7ac1c9fbdb23329ea3e52e8db16939f70"
    sha256 cellar: :any,                 sonoma:        "f1eb0cb4c7f468a6d5b902c4a3f0b5281804019fdc630318a7bca4186089ef5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44b914d31b24dd4fc4fbe2b3c609bf703f355d37abb21658c9a79ab792c48609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "238fa8dbc6f6ef4e325f85fc625165506e82bb613698d66051e7e1e190b85f22"
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

    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end