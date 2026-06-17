class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1127.0.tgz"
  sha256 "89a948223288fbca1483d438b7077315b098a81b0586c3d71932f3182fe61ff3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9262c60a20f476252b6643ae69a94d89c1de00da587e0619e3f6eaf256c20860"
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