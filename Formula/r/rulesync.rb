class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.6.0.tgz"
  sha256 "95e0cf10428b35323498401d24b27b3586f52cc438e17e9bc2396a70206ea37b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d8193586c32d7155631476936fb65f5cbe7f644e8078f1afc410f1dc173fc087"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end