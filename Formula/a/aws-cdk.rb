class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1133.0.tgz"
  sha256 "26d28e1f30d7c1b776d60435dfe5d56f2695c9efd239a802b48d9e0a0894232a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a147ec400ac4ace92afdb592d83a28d2839d94e80c4ab42d989fab80bfcecbe8"
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