class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1116.0.tgz"
  sha256 "c08eb241b3cd0964ac99f2e14a04ff715f75789fd2855be0620a6ae05fd2175e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c4b4a268a5785b1eaa47d50418403c5ea0edeea300474cf991f3d33cb78932e"
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