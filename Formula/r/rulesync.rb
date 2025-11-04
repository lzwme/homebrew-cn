class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.6.tgz"
  sha256 "732fa74560fe21a5ee4209a51315afe5a20fe98556f43fce369e376ad15dab23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c84efec40fac78249a56b2f15c6870a7bad5380625770a7b9feae71c11657acd"
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