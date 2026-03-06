class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-7.15.0.tgz"
  sha256 "6073f051b7c844a3a3553a82e792fc55664859b9dee6790978a604822df1c9e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3849e70db7d8e06a18942129259b0c52328c58028664c0efdef2c7d0b8ac6255"
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