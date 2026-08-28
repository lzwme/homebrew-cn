class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1139.0.tgz"
  sha256 "9846bce8cf52aef8b55f27880b305808abc744ff72c74a3b238fc15bb5cb3f17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e142a56a57cd847c28b447321f5f4667875ad00ccf6ecdd30e6eae68f4b7c8a"
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