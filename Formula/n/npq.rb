class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.19.3.tgz"
  sha256 "34aa1b08fbe070b421b4d5f07469f638a52c1d94b3e29133697ee8884039b682"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a9903d1dd00f466f2ce6bcc311b2e902a7892f84128812af6944d403176b08b"
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