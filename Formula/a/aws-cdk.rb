class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1130.0.tgz"
  sha256 "a3f8ab7d7d67fa2c2fa83cf7be095d7740a9b37ead1dd6126ac9e87ecc30733a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a3fdf537f93063364edd7235c9b79c96d076fa8745f3cf9e61a1bfd22b16cc67"
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