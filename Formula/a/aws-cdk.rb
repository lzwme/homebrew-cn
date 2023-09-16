require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.96.2.tgz"
  sha256 "b38c5d2c72eb5f978949c74f5eaf6f1d0fa53eb1dce6abea54dd7f3f1db673f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "628d1604fd90ea1822b70575e91264b9f0edfabdd63edee5521bfc64c7a36360"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "628d1604fd90ea1822b70575e91264b9f0edfabdd63edee5521bfc64c7a36360"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "628d1604fd90ea1822b70575e91264b9f0edfabdd63edee5521bfc64c7a36360"
    sha256 cellar: :any_skip_relocation, ventura:        "38f1107a80041b1fe69a24c878485956a515c40c653c8a747912ec512b691907"
    sha256 cellar: :any_skip_relocation, monterey:       "38f1107a80041b1fe69a24c878485956a515c40c653c8a747912ec512b691907"
    sha256 cellar: :any_skip_relocation, big_sur:        "38f1107a80041b1fe69a24c878485956a515c40c653c8a747912ec512b691907"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2324087d68a333b481240165b330ba734f77ca3b08bd3fc8dc1c669e5814bc64"
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