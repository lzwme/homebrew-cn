class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.58.4.tgz"
  sha256 "3f679e5684fc78f454828b244c59872e2f3788b40af47d303c0009f67b5a21f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b361f5c07fe75be71bd42ca19cbadc8818a6cbcf48a45cc5c12858367a0080ad"
    sha256 cellar: :any,                 arm64_sequoia: "d360b21a2269bad214e456e7fc316ff7fd2c38df54ba048f9030485b94da725c"
    sha256 cellar: :any,                 arm64_sonoma:  "d360b21a2269bad214e456e7fc316ff7fd2c38df54ba048f9030485b94da725c"
    sha256 cellar: :any,                 sonoma:        "4aeeb9608c425098dae0db1ebea2b955d4e3966c03e57b2b77f3b6bc93eb1fdd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efbdf886e0aedd90692428692416ceda03b020a5845a7939b86b45f36cb1a5b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f0aa853ab83dd68e428e2bb37efc7cfa0255196350005074839029b7cd3f101"
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