class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1014.0.tgz"
  sha256 "ee9d2144987a229d9a3cf7fc11e6bd9f5d24fed24ffde5821bcd04240d8245c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e1054ae9ad697a36933b0373319c6d95c95179dad8f33ec4950be358b4e685a"
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