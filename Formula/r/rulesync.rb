class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-1.2.4.tgz"
  sha256 "0d038fbd77b6953689695c8fe376dc3c94a050c6a2f1a30d45c3d71c645aea4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "909cb05c4c871aafdce6b6884c50aab32b1eeb20f7dcb5a09a5ce21288c5749a"
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