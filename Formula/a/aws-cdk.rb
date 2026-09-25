class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1143.0.tgz"
  sha256 "27a1c3a5a67e93ca1787097de920e6880217cac8f5f24fcc2cf4912cf93f2f28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "17580609423e0a18298912f3717e1736950d259d9734eee0910420880addd0b9"
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