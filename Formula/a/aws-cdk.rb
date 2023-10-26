require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.102.1.tgz"
  sha256 "59360259fd53fd5a596ff65472e195dd97ea26c8c7dcd7faa3a6f5e3b2ca7cf3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "040ea5cfbb1b6bfbcb3e469346d1ef2cd3b0cf39ddeb8755d5d88f6561a2f7ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "040ea5cfbb1b6bfbcb3e469346d1ef2cd3b0cf39ddeb8755d5d88f6561a2f7ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "040ea5cfbb1b6bfbcb3e469346d1ef2cd3b0cf39ddeb8755d5d88f6561a2f7ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8f390cc8cc90cf5eb737903dd6629353b78b1b66cf9b410438e477944996fa6"
    sha256 cellar: :any_skip_relocation, ventura:        "c8f390cc8cc90cf5eb737903dd6629353b78b1b66cf9b410438e477944996fa6"
    sha256 cellar: :any_skip_relocation, monterey:       "c8f390cc8cc90cf5eb737903dd6629353b78b1b66cf9b410438e477944996fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92247677bd8433a499abc343cc5f842cc9db950cdda4750dd70fc1c9cf57ee87"
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