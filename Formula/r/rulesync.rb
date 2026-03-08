class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.15.2.tgz"
  sha256 "ccfa7dea606b4e774305f1f5bdd16f5917365d37c0a25716eb3dfef046241f74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab6ca303aa4e92f7102e04071cecffffc01db9c94875139a0f42d1586e2a6f1f"
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