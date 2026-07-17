class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-11.0.0.tgz"
  sha256 "c49d683f56dded6ea85a423c87a2353995e8ebe95438d9cf75d292f942a69e90"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c90e6cc672369ca0c87b3dc9c2b0293c3d3e3b9db26a0ff494f65b4b4643f008"
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