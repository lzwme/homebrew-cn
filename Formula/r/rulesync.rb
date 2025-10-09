class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.4.0.tgz"
  sha256 "3dd4946205bfff48fef3a3d170c5ef4ed6eac1717144336048067374b07c77d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b700b56efd8d7981122c72bdfeb3e21243e98542819e2e2efed1ca854fc85a1a"
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