class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1111.0.tgz"
  sha256 "eaac411ce8f0adf7a4192f9cbf69be520247fb27e635224a19b160fd22fa0633"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "55f6e3037655d08e8f6f9e8a1271c17a73328b5d05fc7890a8324c2bdb6c026e"
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