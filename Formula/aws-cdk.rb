require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.73.0.tgz"
  sha256 "b0c9fdae2365747df4804860bcc0007f36fc5cbf9084cc85aba0d755a0166dc8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa8ae419f8b9e530b4bef663714c51d3963e242fe86f3c8a221ec6791af92eeb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa8ae419f8b9e530b4bef663714c51d3963e242fe86f3c8a221ec6791af92eeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa8ae419f8b9e530b4bef663714c51d3963e242fe86f3c8a221ec6791af92eeb"
    sha256 cellar: :any_skip_relocation, ventura:        "0103040cfe820e6ca37e4c8f6e1ee9ccafbb224f4bfbca9d1ad5b6693aaa0940"
    sha256 cellar: :any_skip_relocation, monterey:       "0103040cfe820e6ca37e4c8f6e1ee9ccafbb224f4bfbca9d1ad5b6693aaa0940"
    sha256 cellar: :any_skip_relocation, big_sur:        "0103040cfe820e6ca37e4c8f6e1ee9ccafbb224f4bfbca9d1ad5b6693aaa0940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "073eae94b1204b448da144f6d0edd8727d8b840ad5fea53cca42b402e88870bc"
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