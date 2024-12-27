class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.173.3.tgz"
  sha256 "198af43c577dcfd4e89b47baa716a029b91cd7942b30cd5e6622a9dace4dacdc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c270c47cd6fe666d072f01e3d8bf61cbb720c1fe7cd3ece3e97838d4783a1ec9"
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