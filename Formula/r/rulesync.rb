class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-26.0.0.tgz"
  sha256 "5e89b10d2b75c91327fc5fbe3551752ed9a7b17b81447bd1116e67dc10676fd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "050a2f253091333bcd859f8e89c3060dba6c2331867436ef6e57f9ae821006d4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "050a2f253091333bcd859f8e89c3060dba6c2331867436ef6e57f9ae821006d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "050a2f253091333bcd859f8e89c3060dba6c2331867436ef6e57f9ae821006d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c3a26a5abe74472757049adbb107a72fb97ea302bc72e1e5124079d1362cae91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c3a26a5abe74472757049adbb107a72fb97ea302bc72e1e5124079d1362cae91"
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