class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.12.1.tgz"
  sha256 "455dbfa3150b333bf4d3e2486744ee131a2a4e1475e32b496919ed1afdef6e81"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "141a3f0c3acc5732af99571d7beb4fadd7364298e55bda48ebe397175c5b15ee"
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