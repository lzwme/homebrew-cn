class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1145.0.tgz"
  sha256 "298ef17e50f63115d4c69118c48f0d06d5d5a27c72a3c5c498f60e65a3a9ef7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6bf685d4a9685386904c38b9c8a73b6d9da5c79332906b4ca729ff193d5ea3c0"
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