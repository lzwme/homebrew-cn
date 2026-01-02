class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.0.0.tgz"
  sha256 "08ef4cc5405f9a485a4567aa2b2b1524f4153f6201c8c983194dcce5338e53a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c4423c88fcd546cc5447676ae9aa33709a88c926cbe0c247ef9e7aa294c3eb0"
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