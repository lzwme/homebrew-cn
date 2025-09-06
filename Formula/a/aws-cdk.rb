class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1029.0.tgz"
  sha256 "90dceb23145f57f911c07d65a85a7349857540933b66a75d8d94d7d81825840c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a879eacd0a5f43c3cfce957aec09d4bd24966c440dfd0e1906efcd950ee96ee2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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