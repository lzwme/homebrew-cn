class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.19.5.tgz"
  sha256 "1e44c1dfa1b61f1b1afa56207387ac3f52587cfae4ae0e6261f9381345728369"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1acef04d7eb95bdefa7bc92c28b0481e447c5a23ef37ae207c12b6348cab50d5"
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