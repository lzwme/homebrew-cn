class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.10.0.tgz"
  sha256 "f82c0ac6ebd1bb13bce747adab74f5249e7b8279001a50fd0b5a280ba0760a89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed51b58d4c20dbb26a12ae439029a03ad3d40711b837c45d1597b6b38541cb47"
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