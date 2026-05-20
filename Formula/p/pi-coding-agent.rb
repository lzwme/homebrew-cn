class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.75.3.tgz"
  sha256 "6992c0a32f0185126e2551ecacae782b622def9422021ba2e7ef75381b74168c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ec1650a277207296b426d3c09c50f6a546364396ef3c2af2ef609452bcb630f4"
    sha256 cellar: :any,                 arm64_sequoia: "2da53bd401944cbe96922b577f28c2a2a07d8a97439c2f8c63534d0d2f2a9545"
    sha256 cellar: :any,                 arm64_sonoma:  "2da53bd401944cbe96922b577f28c2a2a07d8a97439c2f8c63534d0d2f2a9545"
    sha256 cellar: :any,                 sonoma:        "4067d41212ef079817967caa9dc445bd277652c8f3816d01f817aa75b3764770"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f19f8a93c276a65c4210701462e5e15bd5f427aea4808e9dbdc686805b5444c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9343745a4f96408875a7c62ecd311dd92c144fbb38c2e6e61a899ec157706e98"
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