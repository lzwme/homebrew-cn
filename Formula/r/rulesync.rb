class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.11.1.tgz"
  sha256 "d10f3aab1c0100b6c113bff3675a46b8c8254bb419f8eed8fede75c96dee4ccf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "87f4e1926976691f484bc9e0b4ec3a4062961f37f34c82691a8cb104a986d278"
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