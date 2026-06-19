class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.30.0.tgz"
  sha256 "7a412d000fefbb23e7a8519d439fc5f0bdc01b72176a2a37aa318295a154d7a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df46b20f0eaf26e17b806071fed8b90687b85313330107bf88cf03f671ceb2b1"
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