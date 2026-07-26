class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-15.0.0.tgz"
  sha256 "7c4c74b2153897489184bf180daef48d4176b607a17bbb702125fe376cd33930"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10b44d5ce4c6f54d0222ef39255cd13c0b0d14522dd8eff24ed5c8347e544a2d"
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