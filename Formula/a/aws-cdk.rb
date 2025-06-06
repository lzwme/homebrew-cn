class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1018.0.tgz"
  sha256 "2a042ed15a41f0007fbe259378e3aa45efc217038f4aa8d72e15b076a10e9995"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6162852ca8ca7c57672b1535ab9f51e4bf04ecb905f1381885a7a8ea494f402"
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