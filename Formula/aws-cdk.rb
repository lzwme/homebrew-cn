require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.67.0.tgz"
  sha256 "23fd01b28d945eb6af155a12e171f2d96de41e2187d29a459baa4081fe8af941"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "373c3b13392cf6cd7839a3700e59597db77504868fb34c1dfd79dae35d4610cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "373c3b13392cf6cd7839a3700e59597db77504868fb34c1dfd79dae35d4610cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "373c3b13392cf6cd7839a3700e59597db77504868fb34c1dfd79dae35d4610cc"
    sha256 cellar: :any_skip_relocation, ventura:        "5c70a15e2df3a6fe8bb4fc2448d562dfc5c541fb5a64f4091ab831fb025a68a4"
    sha256 cellar: :any_skip_relocation, monterey:       "5c70a15e2df3a6fe8bb4fc2448d562dfc5c541fb5a64f4091ab831fb025a68a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5c70a15e2df3a6fe8bb4fc2448d562dfc5c541fb5a64f4091ab831fb025a68a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd4aad6aa553d42f9fc197452ab193905ead4903465d170b15d75b062608121"
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