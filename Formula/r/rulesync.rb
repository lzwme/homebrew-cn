class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-14.0.1.tgz"
  sha256 "cbc05b79217773c0f4b9c3d2bc418ab77f1bd150d437015f76755ed3d3372bdd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16cd0469bd71bc6b76f41c377945ef0a270f22a2307c2bd476a96ca7b7252202"
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