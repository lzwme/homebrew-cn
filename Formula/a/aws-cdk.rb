class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.171.1.tgz"
  sha256 "5e23fe28f68a629a68618a8e96da3d6ad1e8c3a83bcbed58f2e61ae061e7ef37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "74dcc7a68b48d0482437fb40b663332c318f553d0ea26310782f1fe9c1fad4ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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