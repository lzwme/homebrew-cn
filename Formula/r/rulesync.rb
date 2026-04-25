class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.9.0.tgz"
  sha256 "6bedb198f3bfeb99ac1a01b47343a26f83d6c5b07e20a7413d4fcd8e84b8b214"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6dec01c930382da505d3b28698cc34ca3c8856184001cbe35e4f31df262d8b3f"
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