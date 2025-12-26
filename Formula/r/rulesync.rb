class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-4.1.0.tgz"
  sha256 "c69c1da9a4293d7799d3785ae58849b06bcc1b7bf14c75e4ce0192319286bc79"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1f588b3f31c3639cb8dd10e31690c867b9f2c492abbf830f5472f9a4826c85a"
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