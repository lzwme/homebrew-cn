require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.104.0.tgz"
  sha256 "f0d38ad8d817d5fa1d0d12fc98bfe4926519e9170352c476e4ebe2dc2bde5975"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87b412244d6eb0b16a1c02b6788a2f349bc86c3c6e009c9397590ee02545e822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87b412244d6eb0b16a1c02b6788a2f349bc86c3c6e009c9397590ee02545e822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87b412244d6eb0b16a1c02b6788a2f349bc86c3c6e009c9397590ee02545e822"
    sha256 cellar: :any_skip_relocation, sonoma:         "666213ec7374925e61077cc739c0f433e1b09c5ee6f254aa8cfdaa0b464e46a1"
    sha256 cellar: :any_skip_relocation, ventura:        "666213ec7374925e61077cc739c0f433e1b09c5ee6f254aa8cfdaa0b464e46a1"
    sha256 cellar: :any_skip_relocation, monterey:       "666213ec7374925e61077cc739c0f433e1b09c5ee6f254aa8cfdaa0b464e46a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28aafb237f4e47c81f1e27372ca2faff2bf6c782dd2fcde2955a3a8cda698c39"
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