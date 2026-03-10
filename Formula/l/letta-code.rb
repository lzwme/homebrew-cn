class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.17.2.tgz"
  sha256 "a9ee4512afd4c0972a92f5433c1af2bf5fd8dd61bc5d698bf17d31891503d61b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d7ce6258164a62fc252037fa2464e608951acf2affc14b4e5c8dee94e9b9afa"
    sha256 cellar: :any,                 arm64_sequoia: "68c35653f031639ac0608e7a0622aa7a9278d3105817da7fedea7026532ec97c"
    sha256 cellar: :any,                 arm64_sonoma:  "68c35653f031639ac0608e7a0622aa7a9278d3105817da7fedea7026532ec97c"
    sha256 cellar: :any,                 sonoma:        "da80d01a9667825fdc6a3f1fffd9b238d42b551692fd36b7505d5fef33c94c2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "682a1718fc1e9936e284ab73971a59fdc2d33deb0c74ca74943dae823540f57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aa6ce8649514306ed7caf2ba8dc6b887a4506b672e44fc61686bef3b1d73030"
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