class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.15.4.tgz"
  sha256 "808ca438809f59db369fa915cacb362737614cf21782cdf70daa05bdc515fdd2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc5bd1c14e843bd86a2c9c75fe3b2e5d1d9f3443581689a090d1e2d4a6ac8818"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq --dry-run")
    assert_match "Packages with issues found", output
  end
end