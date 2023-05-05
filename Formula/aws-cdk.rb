require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.78.0.tgz"
  sha256 "7485bb2262a46fa76710b057304258be1525be1d693807862e5a2fc589bc468f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aed8ca7dcab3cff0d5b1f23c2dd776375fa4f63da12f6a0ec666314f1db8ad27"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aed8ca7dcab3cff0d5b1f23c2dd776375fa4f63da12f6a0ec666314f1db8ad27"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aed8ca7dcab3cff0d5b1f23c2dd776375fa4f63da12f6a0ec666314f1db8ad27"
    sha256 cellar: :any_skip_relocation, ventura:        "2db97b10a87e3de4aabfcf9211cdf10e69d8c0e76554e1046dcf14a65aeb31cb"
    sha256 cellar: :any_skip_relocation, monterey:       "2db97b10a87e3de4aabfcf9211cdf10e69d8c0e76554e1046dcf14a65aeb31cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "2db97b10a87e3de4aabfcf9211cdf10e69d8c0e76554e1046dcf14a65aeb31cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e7fd5791200a7f248208a35d291c56a7f1974014b5160263ae5328c237e6cd4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices.
    deuniversalize_machos
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