class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.18.0.tgz"
  sha256 "08423346bb46cb33e32911ae2d1aa3d5856c54104720cc595fd96aa726854b96"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2b1f2035d85dddb8312e327a6b018e7283421afe406061ee83e1f95843ec087"
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