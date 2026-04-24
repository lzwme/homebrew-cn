class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.7.0.tgz"
  sha256 "e6aafd17b213db1cf9e3493b454357396c77d47a1b577ef7e0ba0dbdcb57701d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4cbc4e12cbc96b4c701ab943224129eaa9a35eba1542e0ecbaa2fc18de827f5f"
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