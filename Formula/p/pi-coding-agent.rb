class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.72.1.tgz"
  sha256 "972bd3d52caf7ec41ed9ae66ef51dff9ac0ea3b08f54d470bd27f74c27167946"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac2a6c5a1b618c70718731239c07d55ab5aa45039ed7209981d39aa6dd230090"
    sha256 cellar: :any,                 arm64_sequoia: "92a03d170ab3ae98d4a59b975feaafdfaeff7875ddcf05409485b8510f09aa5b"
    sha256 cellar: :any,                 arm64_sonoma:  "92a03d170ab3ae98d4a59b975feaafdfaeff7875ddcf05409485b8510f09aa5b"
    sha256 cellar: :any,                 sonoma:        "1503e6096d1a37219353c13cd60d528809ca344cf00033c194722d51c8a77bef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "807b76fea25f0e6da8731c4d930024715245ccee9baf5785ca46849d11cd8f0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f31060c6ffea0a287e560b8ca4a9a3575b713cd6ba9e1b33f22b653f819ab240"
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