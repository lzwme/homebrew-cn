class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.24.0.tgz"
  sha256 "5c273a7ba7038edd92db0f2a4f3d6dcb1dc7157a01b3d4e42105a52e9c800a8d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bdd544b6428588370f6ececb7d0eb0465789c24a312f843dedd84eab4dd30941"
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