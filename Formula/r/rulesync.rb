class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-9.1.0.tgz"
  sha256 "1886c4fc8716dc0aca26d2592a89a48cea60544c3b74f0f04b5a797d81addb9f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "62c7b02c50cfd97992642689a7d32ed6b8a682567513dad70140b1ece56bab1e"
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