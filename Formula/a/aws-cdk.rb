class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1032.0.tgz"
  sha256 "ed5f0b6276b910a1d21912c2ce56980a3b701af36246c877ff0dda683d7c0ae0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2af445c89135ada35b28196fb48f71ce46be68853ba0b63e0cdc15f5e91c05ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove empty `node_modules` directory on macOS
    rmdir libexec/"lib/node_modules/aws-cdk/node_modules" if OS.mac?
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