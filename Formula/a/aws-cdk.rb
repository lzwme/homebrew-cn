class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.164.1.tgz"
  sha256 "2d4e15a1d9a46cd16e422a4c2252e36f6b3f512bc804e69106b853b5d4c27552"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e6df317370fea0f3570d81ceef45dd235b0d5fa946e70955b0bcc2a4ff8c2d1d"
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