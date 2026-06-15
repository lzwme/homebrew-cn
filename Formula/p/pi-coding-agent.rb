class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.3.tgz"
  sha256 "fb28cbae9a91bc7a3e767295042765fd7e262183cae742f01c0c74b20c8de328"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8bc67794b0dc514d4de128e4d2198db56896400e7352ec7af796b89d956eef15"
    sha256 cellar: :any,                 arm64_sequoia: "f7e271b0dc099faa7743300ade370b5b8c2805531553ffcbebc31b648927ee67"
    sha256 cellar: :any,                 arm64_sonoma:  "f7e271b0dc099faa7743300ade370b5b8c2805531553ffcbebc31b648927ee67"
    sha256 cellar: :any,                 sonoma:        "92888790aedc2d02854b0292a1861166d6e5c71274d9449c200fe16ce7575f81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f304ca40cbd9043fa5ab958a22240014b46b317a34f668dc158b2b568affe47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25da679df8dfce5196a94e637e7f8a5cfe0c998d704524f5b32da2b5f28d26eb"
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