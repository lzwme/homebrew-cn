class PiCodingAgent < Formula
  desc "AI agent toolkit"
  homepage "https://pi.dev/"
  url "https://registry.npmjs.org/@earendil-works/pi-coding-agent/-/pi-coding-agent-0.79.0.tgz"
  sha256 "6542796e34f2cdb3617d296c3ca4e923572cf4e0073a59be45cf9a0c0f9b7263"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7427e70dabc9ffa983e6230d5532c444ae4f5e261bfda194787827e165eaf3b8"
    sha256 cellar: :any,                 arm64_sequoia: "6f740526d6b459e25d79ba49d006d31d113053ac50396022e67aff49391775a3"
    sha256 cellar: :any,                 arm64_sonoma:  "6f740526d6b459e25d79ba49d006d31d113053ac50396022e67aff49391775a3"
    sha256 cellar: :any,                 sonoma:        "34b22b3306b6c71847ce01befb750977dea5be6e6364e2a506b380ceff50db6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9549a204df3bf8ad213efe7e4d26c9efcd4220ee087c1564ebf1de9e0752905d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beb9318a25d248fd18ba7015a7bfcc6f91d0fc60f4c421c38f4c6595b6d812a4"
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