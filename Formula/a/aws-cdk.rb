require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.91.0.tgz"
  sha256 "aeb68fec2099f343b41fd171f38fc8493bdf45940837234a0cc3bac2f3413be5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b64fa1b09acb75c80851f3eadc3d021d1f3307175c0592685b2ba28517fd5ae8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b64fa1b09acb75c80851f3eadc3d021d1f3307175c0592685b2ba28517fd5ae8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b64fa1b09acb75c80851f3eadc3d021d1f3307175c0592685b2ba28517fd5ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "e2787194156e8cfbb9fc4692b1dd97485d52bec255b8ba28151bd2f23121bcfa"
    sha256 cellar: :any_skip_relocation, monterey:       "e2787194156e8cfbb9fc4692b1dd97485d52bec255b8ba28151bd2f23121bcfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2787194156e8cfbb9fc4692b1dd97485d52bec255b8ba28151bd2f23121bcfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c751a68237d1b66074803b0d69ba9e1d67660e7f712b2ea92b6cba4f43afeea"
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