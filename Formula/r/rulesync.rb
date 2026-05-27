class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.20.0.tgz"
  sha256 "6fe135a6da230637110785ef649e77648fe4c3df1751de00c1ce9162a7bfe121"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1e5138ab6d8a336997dd927d2c5276c2c0b545b99d36e61729b95c9ef4e79353"
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