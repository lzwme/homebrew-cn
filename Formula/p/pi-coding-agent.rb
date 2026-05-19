class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.75.0.tgz"
  sha256 "0bf04d71ffc1669c381a988eb786e777ff1d1e09798e76f59db22daf6c4c2f3d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d277f8134af300e37bdc0c03970b3f45388e0f15ba5a41ed2254fbb9a19f3cd6"
    sha256 cellar: :any,                 arm64_sequoia: "bc8007860acace7d5a5cbbd13d864be070bb01ca6d6a2e4d10cf42f0e6118b6a"
    sha256 cellar: :any,                 arm64_sonoma:  "bc8007860acace7d5a5cbbd13d864be070bb01ca6d6a2e4d10cf42f0e6118b6a"
    sha256 cellar: :any,                 sonoma:        "335d6bf3c1e0df0d97401ccf0ddbb25a06b60d008a0654507b5b6b050e030566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "776dac88766416f8d0ea6b61dc8a5ac1531b4a3a0a910d62dc323fce36b9fe6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3b272bd87170a1533fbe3f098963caa691d9f66666efa51a6b19e04d8499ee1"
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