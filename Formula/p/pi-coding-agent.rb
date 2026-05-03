class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.71.1.tgz"
  sha256 "38f9582df815abd1666c834c8b1cc5926c655939a6181a8bc021def60d6b6c49"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7428716bacecdefc7d3990405985ee0f14a92efbdd78bfcfe790a2d1d996dd75"
    sha256 cellar: :any,                 arm64_sequoia: "bce241537ba70d233b5e67f54b474c133751c7df9d8fb7da78c6c77a1aac90f9"
    sha256 cellar: :any,                 arm64_sonoma:  "bce241537ba70d233b5e67f54b474c133751c7df9d8fb7da78c6c77a1aac90f9"
    sha256 cellar: :any,                 sonoma:        "ac4f74a9d2053ba6ad308cd2c1fac519fb68db4b4623236d4813bd3c06b0730d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "370f6f094a73852e496e4bc9269926336d4e567caf1672777f7d3db3ef9e4451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a590531cd1b4d3914dc5aace9c4ce075b3269286dda07fa5c1a515fe19ea9d7"
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