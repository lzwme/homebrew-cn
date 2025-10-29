class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.0.tgz"
  sha256 "0768abeb45ec219d78a296a8f721f6d70b50ebeaedff2d2ebdf94cf40b875756"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15ef9bf8b5835cd0171635721534c6244bcfa3ec59acfc51f13b2ad84b31488c"
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