class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.32.0.tgz"
  sha256 "68d7c4613246736d6bd00a58471274bfc6340479aab5017a234ca31ce329f79a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed4c0e976d942bfce428b134bb5cba2beae861a143f1183bff939921f2fa755a"
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