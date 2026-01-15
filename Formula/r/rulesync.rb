class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-5.2.2.tgz"
  sha256 "0d47abaad82ad127afbc91bd726ca8a517c79a4578190c604b87dc4f00f328bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4b0fca5f51f83c87829a291a938ce72e6e016184e8d71064e8a4be5088f64557"
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