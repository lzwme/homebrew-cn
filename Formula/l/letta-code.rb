class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.10.tgz"
  sha256 "6dcc5830acd0ced79e251e99c230bb6587d767486bec66594b5d884fcf35961d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8817ffa1b562ce5af19f0575da91b12f0e7e1249a34ac19c642e717a999e3675"
    sha256 cellar: :any,                 arm64_sequoia: "e5c7502fde7422287fe07664104e75b193d4aeffb76fc16bd59aca9c77dff7d8"
    sha256 cellar: :any,                 arm64_sonoma:  "e5c7502fde7422287fe07664104e75b193d4aeffb76fc16bd59aca9c77dff7d8"
    sha256 cellar: :any,                 sonoma:        "dfd1aacf8159b33d8f20c553369c80473fd84f5dea61fbc707e735e9c9fddb65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a366a9043e58cc519e6f67b9b55329e55ee4518711b420ffc101fe3e6936dd82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1736237cd20b2a70c996e25e138ef3a1630291b7aed3d4862de0afba997007c3"
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