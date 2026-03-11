class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.18.1.tgz"
  sha256 "2fc3d3eb67e85bdf77c0bcbe41bee2f400f6ff4a2ed651edd6885ab7ec9b8ac2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f76a642ebf5d670c7720a2c644fe8acdeb5b978591c11a09c14b04ce6273945"
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