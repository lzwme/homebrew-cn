class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1123.0.tgz"
  sha256 "5eb91e282c889cab3de3bcc01ec2b8a27a62e0f1ae356847386d083fd6028a04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e35c16f496696ba70dcd2579040d29622ad4776b78a33c61164facff2e99a103"
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