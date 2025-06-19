class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1019.0.tgz"
  sha256 "3fda9bf5a6a8ca3dcc2ea54b0f5521fe339deef835ab08d24b98848235ee7e14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "af10af9759ead9a24ce8370f2b73ff3ed34fa5a6eb026cba598142ebe315c67d"
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