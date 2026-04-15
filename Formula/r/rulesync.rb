class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.30.0.tgz"
  sha256 "b071c42b061bb9b1cbe348b2b298e34efe75a563561b3ef58da4c0a23ac6b79e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9be62eb0d734f1d4373cc3e82dc5b41088f9cbaf1d71811f1506580862111de3"
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