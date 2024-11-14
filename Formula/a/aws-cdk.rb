class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.167.0.tgz"
  sha256 "0dfcf97710add2c30f77b63123e9b3fdeff91ca05a18db922aa2f8f0e17574f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf1a260f5d808b106e0d705a4423f7831248bdda6adbd123f3a932ea4d79d4a8"
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