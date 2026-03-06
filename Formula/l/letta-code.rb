class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.17.1.tgz"
  sha256 "85598581662c9eb7c3a9ab067b8a711016219d0e01951a2d5cc1d9c47adc4a5b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e3de3d96820bcdf30b92c7ab7b47b8d69aec989f8c13f2e4a3d6ee03c418077d"
    sha256 cellar: :any,                 arm64_sequoia: "60308d880d0bce30f5fe014a3103205fa8c93beb75080d8968a541b4a9efab69"
    sha256 cellar: :any,                 arm64_sonoma:  "60308d880d0bce30f5fe014a3103205fa8c93beb75080d8968a541b4a9efab69"
    sha256 cellar: :any,                 sonoma:        "4ba66faf5065ea3e880d333c5219f676fdcaf68f3eb3f7a5dffa424c6167ddbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb2133eb8e86f82675e3d4202bb64150de00ae7030103a0520030ec85a2a3425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6ecb47ab2b8e1c210dfa2a329f71bafdb89a47c3e0fb7a80b5fec6b85183278"
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