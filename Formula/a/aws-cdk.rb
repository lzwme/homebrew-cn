class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.173.2.tgz"
  sha256 "c35c882d838b06a059047589a9d0a1b2f08db1dc9d44b4a1e7cb7985bcc7a2aa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4ecbd6707f866b6afe898628f701ad4918ac3cc2edcaba33614c77e14490b276"
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