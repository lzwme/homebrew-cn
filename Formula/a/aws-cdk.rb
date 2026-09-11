class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1141.0.tgz"
  sha256 "b15b59833d544b82889d1d336a8195184aba706cfa7baad551f0d687b5d38aa1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f384e3ccf600b05fa4986835fb778de1acfd55b75668b6970c749953911f705"
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