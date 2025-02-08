class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.178.1.tgz"
  sha256 "85492d18a5d8cace3dff93a74d26531eb8a9e425c09249d26e832cb009d5f92a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16ab8a53835b10aa1927ac1f6209ce31c0c3d3e3cef0c51c458a644b0418cc96"
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