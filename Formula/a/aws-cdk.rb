class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1016.1.tgz"
  sha256 "ea802df3728aea08e13280807e864d178d37ad1f5560e325b451b32730bd7cca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cfb0f03903473921b7d4d561784e6046eeaaaeaaf6bdcb22ca1b5f347fcdabc1"
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