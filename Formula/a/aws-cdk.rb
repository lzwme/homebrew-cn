class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1002.0.tgz"
  sha256 "77f55c7552501d87e052ed09b25f0bc78f71f296aa44682f53200b7ba0b9c5ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fbc1067c2847b33c215399008e162c54114fd2ceda789b0ab4e0d9054d1d24bc"
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