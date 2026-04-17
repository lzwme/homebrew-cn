class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.67.3.tgz"
  sha256 "b330efa49c6e7732a6abce71661ae74811ce19e92ac228cb744e962200af312f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2537aac1fabd98e46bffb460660758656ce2267a1f38075304ee55bb620f83bb"
    sha256 cellar: :any,                 arm64_sequoia: "91a20a22a898fa6b120451f6cca5dd2348fff40db6a2df1c93f49b66663fc755"
    sha256 cellar: :any,                 arm64_sonoma:  "91a20a22a898fa6b120451f6cca5dd2348fff40db6a2df1c93f49b66663fc755"
    sha256 cellar: :any,                 sonoma:        "2d45e668f5193f516ee8a863daa996ee3178c295c0c62a0f6aef9a4667b6310b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6758dcec35fd723bc7689cd6124afed4bf1eb56fd37435fbba521c5c60493f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7500bd195cddc784c74b82b1c67562246718d07909b996ea02c355d2412c0b72"
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