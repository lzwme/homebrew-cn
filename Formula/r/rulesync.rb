class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.12.2.tgz"
  sha256 "966550197da9e380eb996a6eb61173a4f643eb236405cab643f73e6aa112ae4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7521ee2a69ad4fa987fdb425ca6b1e6b507c77b4c78175341fec1af6906e2a6c"
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