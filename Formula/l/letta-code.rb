class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.18.2.tgz"
  sha256 "5875b7c409e1825ab4c718b09c4b7244088cd26a7eb886d98feccb2db7cb2807"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4346ed2ef211f6adc4ebeff63b564ebb09b5a900848d4c9163d96603cff6dbc2"
    sha256 cellar: :any,                 arm64_sequoia: "bb1f72271bfa6fe15ebb083a02a5d22215b97128a7ed4b62dd89de40439ca4a5"
    sha256 cellar: :any,                 arm64_sonoma:  "bb1f72271bfa6fe15ebb083a02a5d22215b97128a7ed4b62dd89de40439ca4a5"
    sha256 cellar: :any,                 sonoma:        "b2508dec051d5a305c4c05c1200539c55a9a8680745217b82913d2f940e6df70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b20d82a57bcd55381f94260ff658e3b2290f0d3bdb870374048798c3a80bc7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ceca740eed7f3a13a0d0ee2b9e5fa1ed4617c4f17129114bb1fe837357087e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/letta --version")

    output = shell_output("#{bin}/letta --info")
    assert_match "Locally pinned agents: (none)", output
  end
end