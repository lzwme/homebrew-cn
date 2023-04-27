require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.77.0.tgz"
  sha256 "74a75b15af75e2f4aad50d584717a99c8bc98849d09ed1c9a666f77218acc30f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85a1695fddea0a8bbf888f0db6686428667cac1ec49c7bfbb2698e079fa317b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85a1695fddea0a8bbf888f0db6686428667cac1ec49c7bfbb2698e079fa317b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85a1695fddea0a8bbf888f0db6686428667cac1ec49c7bfbb2698e079fa317b1"
    sha256 cellar: :any_skip_relocation, ventura:        "31c9fe89c9e7c11a2551a66116d7def72a09f6b01a572f7caacc19baf9810afd"
    sha256 cellar: :any_skip_relocation, monterey:       "31c9fe89c9e7c11a2551a66116d7def72a09f6b01a572f7caacc19baf9810afd"
    sha256 cellar: :any_skip_relocation, big_sur:        "31c9fe89c9e7c11a2551a66116d7def72a09f6b01a572f7caacc19baf9810afd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "261c9b4238dff184a5d00fdb65dfda4247b69360c1fe636e49db1d2871609a78"
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