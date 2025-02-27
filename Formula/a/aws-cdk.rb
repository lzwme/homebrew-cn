class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1001.0.tgz"
  sha256 "5fb5a41e9d4eb5c5ef2f8e4b93d961460407e664bf0ff6c2d857910d22fbf783"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f3c100dcd3ef1100fdcd89027a1b2cbec7d9e9abc59f794392eebf25d1a06ce8"
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