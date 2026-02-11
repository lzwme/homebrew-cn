class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.0.0.tgz"
  sha256 "7f2421b400a7b59397813fe304deee70b0e6ee30b3aa0c10695846cc3b074762"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6253f9d6610d3b914809cb1d9f8c67673c4af8e531983970f8bbd37cccba1f55"
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