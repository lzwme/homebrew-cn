class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.28.0.tgz"
  sha256 "2c41cd327bd8822afb0d73a7ceb4d9b9410e59a21029fef1420d60536d46c7ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "659a6480b1e84e2440c42c490191230c35ca925545880cce37707776181ce8ac"
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