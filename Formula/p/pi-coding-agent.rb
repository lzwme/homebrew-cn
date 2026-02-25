class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.55.0.tgz"
  sha256 "3b5b0d4620eb89d7e612b36ae05fb6c0c9bdf5f303521a01f2cf4b333a8166c7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4f2548dbe8584aa4ca28b917fa01bcbc9181fe34ae9309b8aa75f3bb702ffee4"
    sha256 cellar: :any,                 arm64_sequoia: "2577619611f2f602374f0e5d5cce931e85403a6cefafeeeef4873d29e7d14e23"
    sha256 cellar: :any,                 arm64_sonoma:  "2577619611f2f602374f0e5d5cce931e85403a6cefafeeeef4873d29e7d14e23"
    sha256 cellar: :any,                 sonoma:        "2422db503628188a45964d56192dbce421f190412f5f57485330f8253512149e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dab71e871ebae63d4efdcc332f2881ab0f0edf882665ac426e25e0936fb8303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "481c88b8312ecb4d6ee2e98df76a22358dc06152d026783288a5980409b3ea9c"
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