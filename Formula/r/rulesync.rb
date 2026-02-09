class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-6.7.1.tgz"
  sha256 "29711f1900da56aa48ea0ee490d209fb784d8b3a38fa90ec51ec2832f17cebfc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47fb2e15ca010c228def6dbace662268e58531e2c3a718bb00a104791e4a982e"
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