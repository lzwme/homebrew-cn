class LettaCode < Formula
  desc "Memory-first coding agent"
  homepage "https://docs.letta.com/letta-code"
  url "https://registry.npmjs.org/@letta-ai/letta-code/-/letta-code-0.16.7.tgz"
  sha256 "564b962f582d34b04cb1c5217061126fc548be8d3d40e1ca083c23302e56061d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b041f9571cc73da5475ec0484a9ef2e4dbefc95cdd73cfdb3d225745c2d7d17e"
    sha256 cellar: :any,                 arm64_sequoia: "8c007396e9d0109815125b5ff1d455e42e6227d1918cce0ced23344e28869295"
    sha256 cellar: :any,                 arm64_sonoma:  "8c007396e9d0109815125b5ff1d455e42e6227d1918cce0ced23344e28869295"
    sha256 cellar: :any,                 sonoma:        "3406b494dbff3b45559e19ef4d51fdddf560cae58ae9bd16a74aefee3891faff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06ffbbc0af08ae512b6b550a0165aea71614fe183f92d0e9f068ab853b674c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a873deffee01d47784f8df1c3473df8589dea07457df6be9ef5ff90ee35d69d"
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