class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.3.0.tgz"
  sha256 "09d4bc0a3248b8587c991979db740d86a713e1c3b2a4bd88f5145612cb5289c3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1dc837afd61fe4d7870a1cb11389abb3cd19140cbe8021186c3fcf62fea1b832"
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