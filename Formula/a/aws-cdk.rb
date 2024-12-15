class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.173.1.tgz"
  sha256 "a6151d6217439b3d34f3c1713198f0ded8a0c2f97d092330031007d8dd3dda98"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "04cb25d0c7c2336668bb8112677135d4ac308d72f51ceae2303f3063dbb96889"
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