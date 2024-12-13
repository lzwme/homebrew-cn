class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.173.0.tgz"
  sha256 "9da67467cc38e8acd633806860837ed672f772cbb6f5451f3418549235fc0579"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d31d6524c5e4e80f96ee4d6c588054e57b34de7b8f8a68f58817bf58d53aa8de"
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