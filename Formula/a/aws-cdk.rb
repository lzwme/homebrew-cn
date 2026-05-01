class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1120.0.tgz"
  sha256 "c0f32ce6c42b5e74768e0c6530064541332795b31f0665f54e3199759075f8cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b45d51b06fd83fb12ea073dca5cd354dbe8b6f68bf80b1fe00c513513da4b1a0"
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