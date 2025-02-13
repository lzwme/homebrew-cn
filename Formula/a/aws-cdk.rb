class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.178.2.tgz"
  sha256 "e1cc251e44d1d132f3685ffc178ebc859f13e188b6c8df92c22da6d455d99498"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d85a9120d4379e7f34e4e3559ef59aa8225509ec53e31af2b834817efe96f84e"
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