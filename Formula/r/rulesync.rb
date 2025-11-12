class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.18.0.tgz"
  sha256 "3472b4b640306f33c9bf3602e9aa494583771999380c66a5a0e7f2404c97f9b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08e2eede6b71a8153f2a123fec9a2fec25962e1d2d077776178efeba231cf24c"
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