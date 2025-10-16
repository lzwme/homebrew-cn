class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.5.1.tgz"
  sha256 "a01a6e821dcb051543ee0039c6c99ed88af7fcd180f0a63e4967e8804dba4b1b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5ffb86606c98216268d21cc26a3130d17dfd836d7676bab62409189cc0e2aef8"
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