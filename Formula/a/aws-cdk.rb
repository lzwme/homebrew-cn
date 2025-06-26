class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1019.2.tgz"
  sha256 "4ed17a33a84bae13803e7b87780e186669ef98ce36a8de6df3f2560177457d24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "765a4f824b13fca850a55ac1e512b56c37f44fbae994d3b8a1ccb0d95754966a"
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