class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-2.0.0.tgz"
  sha256 "59f325052b837aecdf10741cf5f3b55e54465ac2c186e60dccb3454dbd5e27a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1acb4f83b07f180a6f9a97f55277c3895bc9a9db36666e8a97e8d15cbacf34e9"
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