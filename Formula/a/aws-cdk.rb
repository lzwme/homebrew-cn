class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1122.0.tgz"
  sha256 "3a2ca01addef54fedb5099a5c1628d89611ea2339ebd10771e7798e71cf740a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b4f4bcddf83970dca36646feb7a748966d0df289a9c201f764d3d7eb52146c71"
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