class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-0.63.1.tgz"
  sha256 "ba99bff9f9f32eb3341c061ed95a8f65b6680c1a8913dd5c4da2ba6e92bcd5b6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea0a6d15f6a898b92f32c61e45852871644b4fe6ed71b6283628c1c4cdb7a64b"
    sha256 cellar: :any,                 arm64_sequoia: "c3b48bf1d57a021f1d8865ca0743c2bfc702be8e3245d78c34ccff18ae798a5a"
    sha256 cellar: :any,                 arm64_sonoma:  "c3b48bf1d57a021f1d8865ca0743c2bfc702be8e3245d78c34ccff18ae798a5a"
    sha256 cellar: :any,                 sonoma:        "24f05cf02296aa1aa58fa5a4d34b7ddcacc006e5842997330537d960ca0efb7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3b40c5176a4da785d0c92bbd17459fcf48695f6b834bcf488623404957bb000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35dd8d119606d7071916004badc330e28714e12b43865cfe6800260ab6ee5862"
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