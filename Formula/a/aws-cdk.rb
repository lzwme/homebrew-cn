class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.174.1.tgz"
  sha256 "347d2d1b9dd05d27e1665e26a56f6c36881b8267a87dd2a7b17fc0a7035408ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69a95fc414e5eefa4a8ea740b57b378f17ad8fd9f9f27f294bb8bb76046ad5f8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}cdk init app --language=javascript")
      list = shell_output("#{bin}cdk list")
      cdkversion = shell_output("#{bin}cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end