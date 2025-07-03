class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1020.1.tgz"
  sha256 "dbd714c8dc02201a3556766566dc90365420230898b82f66ef11482b1bb04c08"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47e7daa4c9e050a3f9ced8f2164aa0365021a1bbe5992f5de9f17d47b192a6d3"
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