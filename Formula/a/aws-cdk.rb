class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1135.0.tgz"
  sha256 "a93ea06d28edbbe58b8d8503406b4cce03aad12cdacfd091458cc55504eecae6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c62f2ebedb192b3cd115098201b7e49a4adddf63b52164f06e8283a9e43539e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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