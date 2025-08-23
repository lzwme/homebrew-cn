class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1026.0.tgz"
  sha256 "bfc2332fd253f4ab8c7f3b98383e977f6bf83d7d184ae72e2668388d2fb1c90f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83e11de733ba26e8799ca25884c43fce115cf3743c9d78dd24a70e131c84a14a"
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