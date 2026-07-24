class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1132.1.tgz"
  sha256 "6c6589eb3bda866687dd9543262757003aad6f03f7669e3f1e544a7c9a9ceec6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f3f7a7bc03b85f779e36c7043d135872693118b235f34369118a1e85d825d86"
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