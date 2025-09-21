class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-1.2.0.tgz"
  sha256 "2168d1c5075dee5c6e43bb24826f1ea677c9256bd3ade1b3c5a04dd822776327"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "45e58c642b6cc5951dd855067112c735a9fe5597108c9cd714b3c7c96fcb1234"
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