class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1114.1.tgz"
  sha256 "48191f11f03e8b9dc16c5d3a8343d1705a93bf5c8040e543c4187fad89cc1dca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b491f0b5b4f580618a93dab79473b953545b0c76f869688f27adf8c937a5c027"
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