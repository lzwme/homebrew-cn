class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.23.0.tgz"
  sha256 "89867a8c7c560ee0fcfb29b0963e38513b7a998fdd3804adab6179e24e60a0f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4cb01dbce1cf3e1226249bf4e1c28004e743674393fd9f34a03959ec25c256dc"
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