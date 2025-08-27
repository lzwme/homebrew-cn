class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.11.4.tgz"
  sha256 "b01d2ca9612c1d1d0ea5190b902e81c94a7a3cbfc8548c05e671aa0f04488905"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a4cd58c24ca91ce5b2d9ae6f2aeb29ec3a98a404d42b9d3e1fac2856df8318c2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/npq --version")

    output = shell_output("#{bin}/npq install npq --dry-run", 255)
    assert_match "Packages with issues found", output
  end
end