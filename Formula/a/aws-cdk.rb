class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1016.0.tgz"
  sha256 "1eede4b6872b4891c169511ab65777f2253ce9f62e63d63ce8e4558c5c25a7ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6614fe9deba8c225b990e31d2cdc99612da934e64457b0f421781dfebb1a2d30"
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