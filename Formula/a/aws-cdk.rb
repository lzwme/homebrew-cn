class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1118.2.tgz"
  sha256 "f68f2c81923846218d3c54b85a01ffbdb0495ce692b4ddafbcf01fc09db29d0a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12a9735b4e26456e59c04ad1f18f53614f41bf0a1029ba1c6d00a6a3b5b4663a"
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