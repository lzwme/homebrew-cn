class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1017.0.tgz"
  sha256 "095f4452d6becff5a1d86cae902e5b27e1c093548e03cbb69c71588cfa174219"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b01579c1c92b5ff9b44bdedb2c03d05602746ff4b8bf7b201f0b2cce626c5e1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}cdk init app --language=javascript")
      list = shell_output("#{bin}cdk list")
      cdkversion = shell_output("#{bin}cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end