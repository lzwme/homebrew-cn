class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.58.1.tgz"
  sha256 "2ca6c7de9c2b7c4d1bced79b894abce02c35d4eaf5370fe3de55321b2d75ba0d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4ba495a8644968f55b9e0252e27d6a18f42cb753d422ec0cbcc6cfb5d419b5d"
    sha256 cellar: :any,                 arm64_sequoia: "19d1756d19210f452fb82909c153c10d29a2c552d6e198adc918471e58dadc8b"
    sha256 cellar: :any,                 arm64_sonoma:  "19d1756d19210f452fb82909c153c10d29a2c552d6e198adc918471e58dadc8b"
    sha256 cellar: :any,                 sonoma:        "67d1f04bb26e3ca9fccba1248fca4e52e706ee88bc85e57fa656d72a4ed23914"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc8859a5b9cdd9f3a0d1428c99d578fe036f2740fa2b9200c169b830792a7122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e7e3820978f70388e453f993b1966d15d5583bb0fc9d1dcd39981b9075b6f9f"
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