class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.1019.1.tgz"
  sha256 "dd3db32c8c3e81cef8e521390960ce5c86fbfe216d940db32590cc24a0eedcdb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41fc612c93aa18160a3af7da0fcfb9a4367f06925188bea28e23522f2bd068d2"
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