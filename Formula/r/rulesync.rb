class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-3.11.4.tgz"
  sha256 "9c390e67f221ded8cacc07d456ca39157f25c1020e1d293fd8bc93ed1e16aa03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d76a890b324db09de9e4aca1f060cb99e69cb866b6859e9a4bd64ae43649e313"
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