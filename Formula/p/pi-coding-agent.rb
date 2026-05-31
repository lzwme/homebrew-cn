class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.78.0.tgz"
  sha256 "a047da75801d9135e368a4711d06d0ca4b6ab708801ab82fd1366dde1eedd0ee"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c46690d949b71a652fef1d9b1ad41c0c3bfd9f34d7d684d89c16768a03cdd91a"
    sha256 cellar: :any,                 arm64_sequoia: "126bcdd158755ad11dfa13ec904b2992ee90548662e5ee3c30360e0d1808d4f1"
    sha256 cellar: :any,                 arm64_sonoma:  "126bcdd158755ad11dfa13ec904b2992ee90548662e5ee3c30360e0d1808d4f1"
    sha256 cellar: :any,                 sonoma:        "ea216f0ae0221c418cd3384f65280ea7f8789ea7b7b59875a81dbf6b362ba56c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c045b203ae607ad1d95027e2a52e67096421c0f9b7f57a66d36f54345fcd1d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1123eafd089ebcf9c8ed14b456b650de4189f6e516fc13af4e82399df71f3f68"
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

    node_modules.glob("@earendil-works/pi-tui/native/**/prebuilds/*").each do |dir|
      basename = dir.basename.to_s
      rm_r(dir) if basename != "#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pi --version 2>&1")

    ENV["GEMINI_API_KEY"] = "invalid_key"
    output = shell_output("#{bin}/pi -p 'foobar' 2>&1", 1)
    assert_match "API key not valid", output
  end
end