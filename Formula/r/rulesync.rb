class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.23.0.tgz"
  sha256 "820e6242a75b6c72b9e2664c17613e4fcfdd30155d8ec2731de3ccb3f1981a2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18a6c83f68cffd80a338669aba502ed5938c41e2a50ecc14369dfec00688f44a"
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