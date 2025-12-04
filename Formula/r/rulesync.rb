class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.29.0.tgz"
  sha256 "898f277cba71e20f9f3a64806ddc9a5c71b0dda84c003f75bd0bd98a0e0e75c5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fbfd73728b71160a6b5a188ff9c028ae622ca2fff5e186106600b4bcb2738bb"
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