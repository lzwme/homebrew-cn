class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.16.0.tgz"
  sha256 "52b17171d81911a324cb88141695fe0cff8b60d98bffded8b2649cefc534e01d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47c11301ce9372ccf9bb12aefeb94c0c318815d891cf73e1723f497910a977a0"
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