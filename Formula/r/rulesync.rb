class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.80.0.tgz"
  sha256 "faceff577ca2f048f174aaf386344f5aafce9c00a5dae34a37fe05c5a4c130b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a58dd4854d20fc008ca5ce2ca3a7a37fbe347a80ba0991a4d7bd9fd1d4882843"
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