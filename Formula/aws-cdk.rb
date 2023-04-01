require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.72.1.tgz"
  sha256 "7a094d49a5e5d91d915ae9866d7d71aebb385d84fab7f6f1387c6956c77a6e30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7ab8bbbbe96702721de52bdde350b46de9c47d954938ccf8bd09e7d4797b5bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7ab8bbbbe96702721de52bdde350b46de9c47d954938ccf8bd09e7d4797b5bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7ab8bbbbe96702721de52bdde350b46de9c47d954938ccf8bd09e7d4797b5bb"
    sha256 cellar: :any_skip_relocation, ventura:        "903b530cf99e71fef8ed5756ac2a3c4f10f4824d55168117ac4ceeb9a7d9f1ed"
    sha256 cellar: :any_skip_relocation, monterey:       "903b530cf99e71fef8ed5756ac2a3c4f10f4824d55168117ac4ceeb9a7d9f1ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "903b530cf99e71fef8ed5756ac2a3c4f10f4824d55168117ac4ceeb9a7d9f1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105cb5a04a0193070386c73fbbdb3b54f2700026a671e6394ad14ff29bad2015"
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