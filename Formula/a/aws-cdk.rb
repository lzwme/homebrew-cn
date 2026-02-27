class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1108.0.tgz"
  sha256 "cbd09e97f91b371b52a68d8dcb49926cf143474343c851e841d75bd680801ca5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f08ed395e22521ee89d56670963a00b8aabfb9160deb5e01efe025dc6d578b59"
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