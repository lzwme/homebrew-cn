class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.4.0.tgz"
  sha256 "57dc3fc75843c75bdbb3571d80da3953af7aae9a13ce399b7d3a908efd2b5e09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a96c57ee5c86011c8bf026bf8b8ee3951e2463c029e8fe7d90e7f5737343bc3"
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