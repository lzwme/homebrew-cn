class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.8.1.tgz"
  sha256 "6c72885c673579cd17fa9bd67936256faed3b1f57e2e5d9a946773c8178ac88e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99df3798aa6ca27792145cb14611c70653edb1c3f5b0a6eb4164e19aebe1ed33"
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