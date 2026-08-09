class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1135.1.tgz"
  sha256 "181b2d36df5681593e86b6015a77dd65b639faa1df093b3b0d492af5e0cd083a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf906905689e06a3f5a1fac6b329b281185365db6139bf1f13df72702c87b1cf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end