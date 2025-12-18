class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.34.0.tgz"
  sha256 "cac6bacbf734704458013e797bf048d452d312eb49e50ad81b5ed07d3bda123a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d06137ff04c2b530e2a24e65a1ee3d9286f0543d1285b526f9cad2f82f721cd"
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