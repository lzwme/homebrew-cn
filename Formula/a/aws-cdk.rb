class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1110.0.tgz"
  sha256 "a398c8c0cc0e6cd9a6151ada1e23737508faf671221ae709f1dce46bc2036d76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a854e9b8af4b5918ca62e885a12a3dcba3baf3a2a58219c175737e8b2a63e67b"
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