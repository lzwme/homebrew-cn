class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1124.1.tgz"
  sha256 "545695bf080aeff6fa776c4a2ae6eef857efbbd291fcb3579b7903a81d7fd5a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "806498563f5b3263fe8ed38bd27764c16afdf4958cde46c4c2524b25667e16b4"
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