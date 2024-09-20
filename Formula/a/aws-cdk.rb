class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.159.1.tgz"
  sha256 "2ffb7ff96ef8e58c2644a33e6b3a605c2db4ac3ae2b567e218b70d46e440184c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7c1e9d0f4f81391fb2ae7213a1728a41a0b84545de2ee6e6f84076846eaea3a8"
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