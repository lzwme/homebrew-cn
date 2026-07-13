class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.21.0.tgz"
  sha256 "101a251ce7d427ab19ea9282fa51bb69e489dc08ede9895b78c71b93e2c7b925"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "570f9faed678400aaee54d4ffee6f9a1a50e3fc5892cbfa31d2339517a91ef36"
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