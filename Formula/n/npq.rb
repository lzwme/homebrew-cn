class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.24.0.tgz"
  sha256 "cfcfca7e2198f2d5b81b1ebd21fbdbbd98cd45c85f67a9dc184ddee0621825be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09bde1f31ac6b05ac6c6e3bdb414c5902035d0f4de0c724c4f1beed97926fdaa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq@3.5.3 --dry-run", 1)
    assert_match "Package Health - Detected an old package", output
  end
end