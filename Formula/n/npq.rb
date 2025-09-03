class Npq < Formula
  desc "Audit npm packages before you install them"
  homepage "https://github.com/lirantal/npq"
  url "https://registry.npmjs.org/npq/-/npq-3.13.2.tgz"
  sha256 "1c7835841877e39d9c3b6740fd48f2c3bd5e9388d67a79487ccf55cdff6e87b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bd09514469632bba3979f957f8c8befaf3e97e8f8410b2650370bdd887966e72"
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