require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.102.0.tgz"
  sha256 "dc35878a2f09dd0a33aa01b2c07a83d45c0a2f9258aef2e3359e52f6f7fa5a6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77e08c1703670e28058ec9d429273ccb1ca611f54420222cf935669b4d6646bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77e08c1703670e28058ec9d429273ccb1ca611f54420222cf935669b4d6646bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77e08c1703670e28058ec9d429273ccb1ca611f54420222cf935669b4d6646bd"
    sha256 cellar: :any_skip_relocation, sonoma:         "e721df661f21e52753934ae3a56c2171cae3e8c4308d05a3379fb52e57761f6b"
    sha256 cellar: :any_skip_relocation, ventura:        "e721df661f21e52753934ae3a56c2171cae3e8c4308d05a3379fb52e57761f6b"
    sha256 cellar: :any_skip_relocation, monterey:       "e721df661f21e52753934ae3a56c2171cae3e8c4308d05a3379fb52e57761f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53348c02b1438601a31130756b8b69d6825b6a85a330ca5a98f22ff167133d0f"
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