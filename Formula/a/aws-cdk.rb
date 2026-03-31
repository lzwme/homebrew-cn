class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1115.0.tgz"
  sha256 "715077c4380ee1bb5e05585c794e54fa2004d9b02c46b4a1865ebcb2841b04f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "536816904dafcc78f5a231723e4bed43f92b30d8309d57b443d22ab103a9bf9a"
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