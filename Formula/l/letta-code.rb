class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.13.tgz"
  sha256 "92a2b390ce6b5080914977772aec1c9704af896b546565f6a40edc8df2ce0050"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76ebbe20f7ece8869c9e82d3f4b3a7137d4c0c217ebef9b108810691fff0fd41"
    sha256 cellar: :any,                 arm64_sequoia: "36a07a8a6389af5abc32dff18f21bb6c7b0fc4fb9d85b1cdb1ff19559ef3afb4"
    sha256 cellar: :any,                 arm64_sonoma:  "36a07a8a6389af5abc32dff18f21bb6c7b0fc4fb9d85b1cdb1ff19559ef3afb4"
    sha256 cellar: :any,                 sonoma:        "f9f5cde37c28c299c82a51c7d58e90da231f09bfd1dc1be81259c11c2e00ceda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "448ef65a1d01336c14ca3cfd21683020f464952a2993d1b5d0d50ee3fb840892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1beb1ec5457fe783367cbb9f460df622b26ae1c592f6e6a4954535b07a2f3fcf"
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