class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.173.4.tgz"
  sha256 "9995a06e64d33c1baa7e843cd02ea8dee04a8214b2bd408fdef8d2b62e38b1a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2377879e55a5588bd7170b95e4e5305fa6d3fcf34c974ff5d33b6e01e0181380"
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