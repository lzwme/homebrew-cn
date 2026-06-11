class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.1.tgz"
  sha256 "a96bbf2c0fa8d2885eb1c86144d924653380653891ccb8e6bf40f66137f597dd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dac2858de773f123fe7d9eb7d5b57a9bf4c7874cf9077dec5195bc5580afd7a8"
    sha256 cellar: :any,                 arm64_sequoia: "dc5c71fc76602a42779fb0f497d9009590bf986674bb106103a9ee4970ce4776"
    sha256 cellar: :any,                 arm64_sonoma:  "dc5c71fc76602a42779fb0f497d9009590bf986674bb106103a9ee4970ce4776"
    sha256 cellar: :any,                 sonoma:        "b4df191207e4c7387c94d261724d375d8be137af548647034f9b9dc9370e9693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d189db729f67a1ea23d3ef645ace4cd5836919051915e51b1395c4d719aedc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcb63285760697ada0513130ebf5cce078be8202ca6251071407b6cce2bab8ec"
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