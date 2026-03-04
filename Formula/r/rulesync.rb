class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.12.2.tgz"
  sha256 "82e4f34c034a0644513207121915b6cdb0b6ce4b1e5ed983d6a4f51c790f8a01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "528d0e43e655ab242d2c377dbdb7efa216d69eed8b3e2db773ac6bb6a50fe73b"
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