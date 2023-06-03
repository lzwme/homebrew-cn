require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.82.0.tgz"
  sha256 "3351ba707089cb0b0f6547f92b174e99a12bb891dbf532baf8d3bfd64ff2c6ce"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "927245c5b1fc7f5cb13f3959bc5754a56fb0f42e296919ee7396b79b595f2685"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "927245c5b1fc7f5cb13f3959bc5754a56fb0f42e296919ee7396b79b595f2685"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "927245c5b1fc7f5cb13f3959bc5754a56fb0f42e296919ee7396b79b595f2685"
    sha256 cellar: :any_skip_relocation, ventura:        "a2a47b5ca026207411081c1aadba3f0325184eeece53a65d925d6dedc6874f07"
    sha256 cellar: :any_skip_relocation, monterey:       "a2a47b5ca026207411081c1aadba3f0325184eeece53a65d925d6dedc6874f07"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2a47b5ca026207411081c1aadba3f0325184eeece53a65d925d6dedc6874f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1038984ac4ae26f8cd6f2d36d80cefb0d50741522f047ad7176484038a34323"
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