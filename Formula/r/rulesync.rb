class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.25.0.tgz"
  sha256 "2147a686f7d893d43fa6706623b4927c560ad78edba2197bfba56c71ec1af95c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a0a5d1aeec1c53088ff68b35dee0418f6dffee3fec887025fc2347496f6a26db"
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