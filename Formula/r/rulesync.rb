class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-4.0.0.tgz"
  sha256 "683e3c05b6d3a2db96c3f723f0b679ca19290638e3e2c1d89403141f128ac179"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "598ede7826068ec926c803434a51c0ac18132fbca7613f8f79f7958597eb3683"
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