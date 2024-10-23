class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https:github.comawsaws-cdk"
  url "https:registry.npmjs.orgaws-cdk-aws-cdk-2.163.1.tgz"
  sha256 "cdf9a4fc5acf8c6f00217748030f13af1d3f2267b8ef1d065aa21ee4a08aaac4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a6dd3a446162c9ff17958734121858c0c047f06aff0ba58f562d626b60eb99f"
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