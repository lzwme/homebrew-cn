require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.93.0.tgz"
  sha256 "48c63e9a8097c0c9b124ace327858d490d831d82355867987d4ffe5884664461"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7a2a90c9a5bbb0445e4346322f786570eb56e066ead4d43aab1d9bb33b307ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7a2a90c9a5bbb0445e4346322f786570eb56e066ead4d43aab1d9bb33b307ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7a2a90c9a5bbb0445e4346322f786570eb56e066ead4d43aab1d9bb33b307ed"
    sha256 cellar: :any_skip_relocation, ventura:        "b375d25bb133892fa9a3641a955c63ba1f7fb53f5564a4ee26777792c0a1216f"
    sha256 cellar: :any_skip_relocation, monterey:       "b375d25bb133892fa9a3641a955c63ba1f7fb53f5564a4ee26777792c0a1216f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b375d25bb133892fa9a3641a955c63ba1f7fb53f5564a4ee26777792c0a1216f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20cab9558267834675f85626754af5d3f1b9c004245421593b30cd7bed270234"
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