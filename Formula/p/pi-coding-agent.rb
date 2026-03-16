class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.58.3.tgz"
  sha256 "aea7f926bed15b770f08e66b7b7c27ac68163bd7ec333c90efa671562f6bd377"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "629986aee9dbe7f19b575edaa3d9722296f0df33c077a00bf0539511fddfae0c"
    sha256 cellar: :any,                 arm64_sequoia: "35818ff9cef9ed2c2312d549097601b8be103f415ed8367c2e482fa73f19f440"
    sha256 cellar: :any,                 arm64_sonoma:  "35818ff9cef9ed2c2312d549097601b8be103f415ed8367c2e482fa73f19f440"
    sha256 cellar: :any,                 sonoma:        "0163df5cf7529442fa4868f442f89e8be956b413041d7c49d20dc9da3cbad8a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99e954359fbae58800d70f7c31f06f1e73f2e180453a1b8d4c115e2da91b4913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d775968024b05b88558ee8e7cf87a4a848dfb97b4bf4b34ec2d445532cbe167e"
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