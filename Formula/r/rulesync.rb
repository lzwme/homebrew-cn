class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-37.1.0.tgz"
  sha256 "d29ef0c6749d9c0a9259beadca892caf723245fd57022f206fed32d461c9fcad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "619e31c6e705308c1097679b57d8f1ee7088ce1abcebccf2c13cce2459c6b252"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "619e31c6e705308c1097679b57d8f1ee7088ce1abcebccf2c13cce2459c6b252"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "619e31c6e705308c1097679b57d8f1ee7088ce1abcebccf2c13cce2459c6b252"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4d9383d401c74358d55570838344c0b909fddee7748b43acfb3015b19fd7aa73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "4d9383d401c74358d55570838344c0b909fddee7748b43acfb3015b19fd7aa73"
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