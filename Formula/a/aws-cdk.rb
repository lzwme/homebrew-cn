class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1031.1.tgz"
  sha256 "dec9fc3ca1d17266e582c90513871e338c63c43c9dfcf7006bc4df3588eba7c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "76f251a7c2f0fefd765a243bab8808bb4fc5b8189ed33e3f8fdcb850958a57fa"
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