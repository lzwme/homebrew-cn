class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.22.0.tgz"
  sha256 "86d768b1cc848de520937f156b266f800a48370afa96c1b99faa95c08dc0d11a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0e19fae5c5c5d0f45fe20edd2159b0e7d025d84822fbc67525942e286846aab4"
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