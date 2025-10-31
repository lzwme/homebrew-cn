class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.3.tgz"
  sha256 "116b52d78f9322b40794273a10f0886564f434cda5def0f8b695789cdca07194"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "929df1144499c0cc5b9dce9a3df3963f154d7b00844552a6bd7f3e37573ccb6e"
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