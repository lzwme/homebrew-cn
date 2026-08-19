class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1137.0.tgz"
  sha256 "e61006e25ea43491e66b02e8142d9eae96ba399342b9b31c86a884e762f05eb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10e2f6ea36a0f6b954522c266c30ff863798490deea4c508a9c3d7f0487bc514"
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