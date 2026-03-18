class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.20.0.tgz"
  sha256 "c6b87eb5b1e3c2603af48259b14175e1841e82bec3cd63f5c99329b3b9f32b0c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9cc41f79973a7fc1a6369b1b978e80eb1254eb9e4591cf154e80d9b1e4578ce9"
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