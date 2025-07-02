class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1020.0.tgz"
  sha256 "b68c43a67a70ea4db0d5cc01a3fb066dce4e06e870921764a876650cf0b4e42b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "597e7d2a4b3d2cd8571282fe527c236d8f21922cde5cbc85ef3b36bcf2989f87"
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