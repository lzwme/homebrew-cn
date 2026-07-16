class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1131.0.tgz"
  sha256 "bdec86f9a7cd3fb4ec1b184c0743dbf5a6d4a75587a264eb9bc19a98a1db5215"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06704f3bec71c29403ccce1867cf6d527bdad34a8bada367af1d85c7e456e71d"
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