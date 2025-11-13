class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.19.0.tgz"
  sha256 "d99d0ec1f263175d07192fc9ef4c963034427c4ba6daf065377510491b614b4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9100a193c674396d1c2db7a080436212e5ba03717f480ef1344116c68a7f83e"
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