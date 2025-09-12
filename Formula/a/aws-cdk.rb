class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1029.1.tgz"
  sha256 "3c48ba420e7124da7b3fb1f59a3bd67ebbf93fe3638b6541b7a5f698e8b56606"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30c4f05a73da0c9635f7507749976de3d546a39d3e8635ea887ee8d03b56c45c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
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