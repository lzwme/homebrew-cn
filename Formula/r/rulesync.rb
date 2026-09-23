class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-17.0.0.tgz"
  sha256 "33b266c28be0cbcd0720ae1ebd636e0aab1238f4cbcc969f5b8e3f1541f5d9ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ace061fcd17bcaae137ea6bf1716a1929b7a575d54459e3321cba5d8a59053a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ace061fcd17bcaae137ea6bf1716a1929b7a575d54459e3321cba5d8a59053a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ace061fcd17bcaae137ea6bf1716a1929b7a575d54459e3321cba5d8a59053a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "887f708db77d6c5d913c3c42df1fc5d1e67d12be851cd142b03dc91ee41259d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "887f708db77d6c5d913c3c42df1fc5d1e67d12be851cd142b03dc91ee41259d3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end