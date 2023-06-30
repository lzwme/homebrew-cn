require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.86.0.tgz"
  sha256 "11a9d7baaf088a975df3451dacfaf7083b5ef64d965490d1c2fc15033958615e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26a7a5e84fb1906d10b4cb4dac60e748fd6cb1114553835bf7fbffc8d61caf3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26a7a5e84fb1906d10b4cb4dac60e748fd6cb1114553835bf7fbffc8d61caf3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "26a7a5e84fb1906d10b4cb4dac60e748fd6cb1114553835bf7fbffc8d61caf3e"
    sha256 cellar: :any_skip_relocation, ventura:        "ce91512e083dd7e38d225bc2173f846bb96bda1796b7a1fb3c4cf57a0f30fced"
    sha256 cellar: :any_skip_relocation, monterey:       "ce91512e083dd7e38d225bc2173f846bb96bda1796b7a1fb3c4cf57a0f30fced"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce91512e083dd7e38d225bc2173f846bb96bda1796b7a1fb3c4cf57a0f30fced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574591bc7ea10ce7edcbe1638490be846703ff789e3beb7b335f9ea38acc5d51"
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