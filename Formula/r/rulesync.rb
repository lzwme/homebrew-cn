class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.9.0.tgz"
  sha256 "6b0e73b21b29b0f808394b87c89efbfeb264e87b93a5de8870dc7234b4d3c69d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24af6ffca62250a0b47614af9bf168af9af83d5e912e6229948d0aa2690d2b30"
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