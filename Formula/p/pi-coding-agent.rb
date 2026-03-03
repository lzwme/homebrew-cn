class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.55.4.tgz"
  sha256 "1a7ccf7b54097058692d9565444be046eff38771935f178afe8e7c0dd43a4222"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b9513c0d3e6fe5e51215f1e95dc1839c6526d098580cac6d9344bfe56948a1d"
    sha256 cellar: :any,                 arm64_sequoia: "ef5e98c5861f230b562a1048a5314c93f09da500e8afebc36aa4667c50d57a3d"
    sha256 cellar: :any,                 arm64_sonoma:  "ef5e98c5861f230b562a1048a5314c93f09da500e8afebc36aa4667c50d57a3d"
    sha256 cellar: :any,                 sonoma:        "57d51f5b97b394c185367de82044b9f5952f97f03c2ca3c100bebdcef09b6f7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6674de73ad490f7243fcf6c3074dbe93947b2b18b64c59aa2959abf91382b84e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26eb69384107934a7a0a848fb68b39871760bf07e8a2f819fd37577822a73ab1"
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