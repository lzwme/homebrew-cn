class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.79.0.tgz"
  sha256 "c8261ae8ff322b30497885da09fcd0ab4c299a0bf4e503ea589b90945a5f7876"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dbedccf4d94dac7e1e92f3886f49c55e41356baf33fc191ccc1b0087aee82e61"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end