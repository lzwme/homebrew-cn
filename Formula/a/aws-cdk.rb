class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1106.0.tgz"
  sha256 "c4c55bcdbb6d11d46f78dbb3d33492324de8add3f700fc17a37caf7538a399ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b2a4cbb763ba544b337930ab6efabc245333e704f55f7a7a9dbf29ef94524569"
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