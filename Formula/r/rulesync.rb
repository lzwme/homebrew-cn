class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-4.0.1.tgz"
  sha256 "7487f6ebd2b4798638fec1d83b38d9fad6333f000c34ceecac552e35c9b5a213"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "03ea080dc24968ae264227b3241c03d05a02bf040a5fbc710cafda42a617c210"
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