class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.30.1.tgz"
  sha256 "67048b07ae7733d89f3128fb7a882204097d9cc77b616ce678553288897495a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd6f7e9892f3842126712675652794ca32eafded123754bac35528ce137467fd"
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