class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-8.27.0.tgz"
  sha256 "5add26e317e6fed0ab8c4431b37430ee35ac563046230cdd01e9f7a3c17c4f7c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "65911216e5b693860a463a7998fc24094f7374eac6b2cddd7fdd6287b0404752"
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