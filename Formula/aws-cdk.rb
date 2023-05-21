require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.80.0.tgz"
  sha256 "1b97508401fd06b2d7045156c50c4f8845c0b33c596782c51ae3e43de54f61d3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c3ee7caaa400cb2e52fcd2fb45fb109fc5acfc0548ce454748c4424bfddec6d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c3ee7caaa400cb2e52fcd2fb45fb109fc5acfc0548ce454748c4424bfddec6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c3ee7caaa400cb2e52fcd2fb45fb109fc5acfc0548ce454748c4424bfddec6d"
    sha256 cellar: :any_skip_relocation, ventura:        "f40750fa23bd8a63ea5fb3e4aecb9f05195bdae59b93ebc00ac8e4a0bf8b6b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "f40750fa23bd8a63ea5fb3e4aecb9f05195bdae59b93ebc00ac8e4a0bf8b6b0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f40750fa23bd8a63ea5fb3e4aecb9f05195bdae59b93ebc00ac8e4a0bf8b6b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5aa76bf489e5e9db6b4eaa95046c2846243e8c53f7d7e88350619cd3c8ba7983"
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