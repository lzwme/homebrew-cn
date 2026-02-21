class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.6.3.tgz"
  sha256 "a5d2a21bb79da6c8bfa9ccc9d64d625c45ecb1e0e51b1e8914e6b91e401bc155"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9dd42f561592419712c35be06f1b7b7bf913a97de402280b4791f5684e1d5be"
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