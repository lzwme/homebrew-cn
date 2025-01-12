class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.175.1.tgz"
  sha256 "c25b23344a12a3d105cac4bd0f3aefdd72b809f7acd9db7c3ed3fe65919290de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dfec395ac98e7c8d2d46e49c7245b91fcac7e57ea8d66165059e9251a29c0974"
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