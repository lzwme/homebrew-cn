class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.27.0.tgz"
  sha256 "1257441f94c3ac74ec2c1a603f609ecdef7ece4c59931b961cfd7b3e1194407e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c35b1042894a6a957d34a48f8e6f67ebe107635e4251a711ed7807e467402338"
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