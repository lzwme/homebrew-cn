require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.70.0.tgz"
  sha256 "47d751f20d7866890c8c6c97b790584f49c28ed2c5f9014e3802212c483a3ccf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c80962a22ec7ab33f4af781145d65c5b1ec7fa1dc492f64d161d682607c73749"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c80962a22ec7ab33f4af781145d65c5b1ec7fa1dc492f64d161d682607c73749"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c80962a22ec7ab33f4af781145d65c5b1ec7fa1dc492f64d161d682607c73749"
    sha256 cellar: :any_skip_relocation, ventura:        "cf95049b69695ca8ee584cff1867ab3989ef2733451db7a719bf141fb1b5da82"
    sha256 cellar: :any_skip_relocation, monterey:       "cf95049b69695ca8ee584cff1867ab3989ef2733451db7a719bf141fb1b5da82"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf95049b69695ca8ee584cff1867ab3989ef2733451db7a719bf141fb1b5da82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf8cfaa823712a297028792ff049fbd9feb93a501d069d04b7bd36391607169"
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