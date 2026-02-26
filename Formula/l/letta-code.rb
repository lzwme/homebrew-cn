class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.12.tgz"
  sha256 "c23671c8ca87f0cab79e7a8d380e29694c37868266b773078bd72a72353bbc19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46881de88f76ffa88fd75ece805cdd3182dbaf149de202d13d6669622ae32aca"
    sha256 cellar: :any,                 arm64_sequoia: "bc253d135cf9c0e9978a0181dceaeb26315f450c86d28d42c7fb9a035e0a0add"
    sha256 cellar: :any,                 arm64_sonoma:  "bc253d135cf9c0e9978a0181dceaeb26315f450c86d28d42c7fb9a035e0a0add"
    sha256 cellar: :any,                 sonoma:        "54773bf27bc7c9bb468aa4950e3b9d687d4967b43830d744e8a1b73ba4aa989f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeb3759285490f4e077e8221a03f1e559b0881945ecd1c617fbabf875142f95a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e63d1ded6c97828384e462d4ac84142f997eba648765ebae4cd96876405e2c"
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