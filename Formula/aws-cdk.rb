require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.87.0.tgz"
  sha256 "d9b900842e5c96ddcf8bb677e1b30f1d4f233d35d13b581e069346e6a6a79c47"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a03710d785a756a03a40157a2922afa1e0a8c6c7c19d54d7c1a32bb697cd3339"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a03710d785a756a03a40157a2922afa1e0a8c6c7c19d54d7c1a32bb697cd3339"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a03710d785a756a03a40157a2922afa1e0a8c6c7c19d54d7c1a32bb697cd3339"
    sha256 cellar: :any_skip_relocation, ventura:        "b25fc15e72cea699a98844794756917ca9cfb9d50e14f3863777e7eff24eec5b"
    sha256 cellar: :any_skip_relocation, monterey:       "b25fc15e72cea699a98844794756917ca9cfb9d50e14f3863777e7eff24eec5b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b25fc15e72cea699a98844794756917ca9cfb9d50e14f3863777e7eff24eec5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c72ce0e4e035026e9a45a0d6e36644a5e5c6aea500b3a4335723661b6b8aa47"
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