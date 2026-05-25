class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.75.5.tgz"
  sha256 "88fff74d1fcc93343e839aa885eacb35e88cdaab97dac2636b11becc3b2499fc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b170cafa34aabd4f1f0a433f5e7907b7abe0167595c8433e4b4a33a1245c0f4"
    sha256 cellar: :any,                 arm64_sequoia: "f34391ea373332a06fb523afe9940fa6c9bafd842781b5a5bee509da2973bb1b"
    sha256 cellar: :any,                 arm64_sonoma:  "f34391ea373332a06fb523afe9940fa6c9bafd842781b5a5bee509da2973bb1b"
    sha256 cellar: :any,                 sonoma:        "8acb7695c69e9494477a89b706680f5c173101919592c31eda33d20947554a88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbb8d95c52a0673bca9e563384814466247b6d98dad67f078ab339d902760291"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77fcea3c1bab5936816a7268a903af5aab7082b231a9c0ff0dd0bae31d468a2e"
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