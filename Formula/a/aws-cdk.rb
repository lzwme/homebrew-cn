class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.154.0.tgz"
  sha256 "b191c450cb7f0bd63007b021be1f24fe9543b11e92ab11c904eb2e67712b4420"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5209f38cc63d5dda0e13d1b5c51ecbddc30d5bb7c47cf447f76334ea6792f648"
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