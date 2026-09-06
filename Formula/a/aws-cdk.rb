class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1140.0.tgz"
  sha256 "d4bf5a687fd440b7c2a4d3f74f9ebcea2d18ca6d6264e2a1b4f4fb2032007afc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a66452e07f667d9a6484f68c9ab82e2013a23d7454131af26dbe8abfcb8d5db1"
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