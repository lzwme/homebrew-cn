require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.99.0.tgz"
  sha256 "74eea385a64ceb3cafca114fb4b12dac422bfd1985aa378b3119ff9fdcdaab25"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "40ec9373fe979ce9bbba8df2b07a921b2fd2ff9924026ddc3708fe9823c45bb7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40ec9373fe979ce9bbba8df2b07a921b2fd2ff9924026ddc3708fe9823c45bb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40ec9373fe979ce9bbba8df2b07a921b2fd2ff9924026ddc3708fe9823c45bb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "8754d1451abef82dfe58198c488833049d194d5585a8e34598aa4f455c342e4f"
    sha256 cellar: :any_skip_relocation, ventura:        "8754d1451abef82dfe58198c488833049d194d5585a8e34598aa4f455c342e4f"
    sha256 cellar: :any_skip_relocation, monterey:       "8754d1451abef82dfe58198c488833049d194d5585a8e34598aa4f455c342e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc6a07bf51df944491695978c9fcb4b8cec99828869383322f3b4e5ea4af413d"
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