require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.81.0.tgz"
  sha256 "76a5cff5ffcc1662d100fa8c26f41ff3ee67a9be49d8e56621e8a2c488a37276"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a029ac4c72777b4026618aa85814029eaa7634a8fd1585eff1372e1ffb889d41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a029ac4c72777b4026618aa85814029eaa7634a8fd1585eff1372e1ffb889d41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a029ac4c72777b4026618aa85814029eaa7634a8fd1585eff1372e1ffb889d41"
    sha256 cellar: :any_skip_relocation, ventura:        "08f7fde12f19a3befdcccbfd646b69c728715b70c0964416bedc3d86f1acbeee"
    sha256 cellar: :any_skip_relocation, monterey:       "08f7fde12f19a3befdcccbfd646b69c728715b70c0964416bedc3d86f1acbeee"
    sha256 cellar: :any_skip_relocation, big_sur:        "08f7fde12f19a3befdcccbfd646b69c728715b70c0964416bedc3d86f1acbeee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c60f7ef4b71100b08242c19de2e489d9fb8b0e761547c24da017781dfea1e10"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end