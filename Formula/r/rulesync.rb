class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.25.0.tgz"
  sha256 "3e1c646978e47c19538850d0c6dc569025e991d8cad65d8200d9605ec11e9610"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97260053e8c317edcd343132a88244d557bed89861a940cd9a4d5a068a8ba01d"
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