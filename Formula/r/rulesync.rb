class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.29.0.tgz"
  sha256 "722a614ed2d6ec9d204f80be03e69e9477a5c15da13cdde6c4b88d0630702c8f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea1559957166673a037521c0d5aab472e2400a0ee02d49e10f9cac550afcfe2c"
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