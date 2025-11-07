class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.9.tgz"
  sha256 "a857957e9bbce2ee92ae9f616c4fbba620101daae51c3bdc94c23651c1e9ea02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4776b13f6055671f7762894eb238bd0e0060186b4ec241517f1d3da16e686bf1"
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