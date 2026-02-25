class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.7.1.tgz"
  sha256 "9997050dfaeb627710a53361e03352d7f763c05db42075316b1bc7e043f0d439"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ec0dbee88996e5dea84c0a0dd94401e8f57a04a1ece6a73e3fa2cd6ec1e7e4ea"
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