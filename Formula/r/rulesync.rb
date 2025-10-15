class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.5.0.tgz"
  sha256 "ff37df2db0c480ccb8c2edac5d990330f3b0184fad4ad17326c68647bf66387c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b561a4bf0b9e6b57cfe671dbec1fae15f88a672ea5f6e7679065b8703956a004"
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