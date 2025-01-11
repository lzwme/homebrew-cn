class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.175.0.tgz"
  sha256 "59d9505ca556c97bfa6be2d9daa18922f57922017ec5d0e71097c28e40787ad7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8eef4ffb74af94abf4c23804ce953368a7d475bee9827aa080e2d23c152bba5"
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