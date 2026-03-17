class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.19.0.tgz"
  sha256 "a727e6bf651c50f2c039eb2c842b528da8fa7d8c4aa48c2d0341be4077d628bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ba1a13c17bec4b397bc6cb5f990fe17bec0be8d7c0235df04b2aa247157d42db"
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