class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.13.1.tgz"
  sha256 "738440e613cb3ff43d2315563919456ea77888b4eac7907a801b31786ac12645"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95bb67958dcf666d0e64b7aae3d7395544c80406755e4dc12a8914168cc447c4"
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