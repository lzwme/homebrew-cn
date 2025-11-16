class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.22.1.tgz"
  sha256 "06964af8f3c1e0f2e9577028614ecbdd2c6583c5fe5027232cf1a450bf3fc1ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2a86469bc448f418f879c28eb42f62a7a0911f9e6ce8f8f93e0e9826226791ba"
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