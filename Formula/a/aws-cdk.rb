class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1125.0.tgz"
  sha256 "8437eb72f5ac16a223d87a12f87374de4f24b7ab8a7a0bbb2dd1d467093ea836"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7671af2102d6c6b170152122b2bc7dc1aa0767d861b3bdf15e035e674edddeb7"
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