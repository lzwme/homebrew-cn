class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.69.0.tgz"
  sha256 "4c00863a46e8db0c206dfb842e371d968354223aa45c3d3aa6c03f8116203045"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9f80db9d3e67b42ccd8c3263ac0b7fe33b641bb0ec9b268a2c394f81aacd099e"
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