require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.99.1.tgz"
  sha256 "b390ce546ce67c072cb473687ebe89e602d07a41165bf0d11c1e0f38e1b54e21"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54ae9dfe029d9d7a84c11a72867454e04f3e9fd093ba8240c0550b6ea91ee4e7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54ae9dfe029d9d7a84c11a72867454e04f3e9fd093ba8240c0550b6ea91ee4e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54ae9dfe029d9d7a84c11a72867454e04f3e9fd093ba8240c0550b6ea91ee4e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8baad3eccc55b4fc554a68cf3100a9754c65edc5d569c2ba1acdf47c98330df"
    sha256 cellar: :any_skip_relocation, ventura:        "a8baad3eccc55b4fc554a68cf3100a9754c65edc5d569c2ba1acdf47c98330df"
    sha256 cellar: :any_skip_relocation, monterey:       "a8baad3eccc55b4fc554a68cf3100a9754c65edc5d569c2ba1acdf47c98330df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f32d1fa13b71ba8911672f2e7be5bfe1343ebd7fb8439b1e51e333022d979f"
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