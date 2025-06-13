class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1018.1.tgz"
  sha256 "053d8151f275e15643e978f363ab0d95ef6982ce2c610332f14963ccb4dd8d39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "39cd0fdb8bbe6753f9ad9994e9d656392e11bd5647909b038f4a490c8343029c"
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