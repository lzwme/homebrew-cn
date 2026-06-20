class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1128.0.tgz"
  sha256 "fb742f7af6546d648e3a36d054d945fc81d3ff817518633e7af2cf839cba72ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e781face7ff8817577bea9e625c57b78bff660e5e97cf946f0afe92d74b76630"
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