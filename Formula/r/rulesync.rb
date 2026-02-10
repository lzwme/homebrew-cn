class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.8.1.tgz"
  sha256 "dc17803823f9576ddaa4687250edd02f59ff702ad396e19804ca589e7472a395"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "07b036c2a3c70b88e697192093fc38c7ba89ab4320a682f7f86c608b537e46eb"
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