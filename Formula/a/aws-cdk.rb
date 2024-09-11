class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.157.0.tgz"
  sha256 "49c3cee4d79906033d2d4e7442400ed008b2aa58c935dc61153c73c3693c400d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c7f2ddc098b1d6c8b9466aef3a0e2bd333baf04961ceaf49ae793a9ad521f5ac"
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