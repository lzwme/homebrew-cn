class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-0.75.0.tgz"
  sha256 "116e2c5f86e30ba91a00f161774189ec148964e4229dc0a5c38701770c7a5591"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e935fe4d35e09ad5eb757cf913cc6cfd2cac10163e6ae51f00a3d7dee04728c6"
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