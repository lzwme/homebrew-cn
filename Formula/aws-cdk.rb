require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.66.1.tgz"
  sha256 "fde67b7e93a8c0ef81b6ff1acb6b0eda37ae0509f966e72b8b92edf02dc67ebf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d0aebfdaf1619dae0ea921b2c54b2b49feda4f66f6cbc5230694d35a0decbd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d0aebfdaf1619dae0ea921b2c54b2b49feda4f66f6cbc5230694d35a0decbd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d0aebfdaf1619dae0ea921b2c54b2b49feda4f66f6cbc5230694d35a0decbd0"
    sha256 cellar: :any_skip_relocation, ventura:        "e076227fc63b11c2447a91fcfda53da829db8657db14c3068373829a5ee2accf"
    sha256 cellar: :any_skip_relocation, monterey:       "e076227fc63b11c2447a91fcfda53da829db8657db14c3068373829a5ee2accf"
    sha256 cellar: :any_skip_relocation, big_sur:        "e076227fc63b11c2447a91fcfda53da829db8657db14c3068373829a5ee2accf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15667a55f708a8f3f71f71a4ffc3b555005568ef798b8d4bcfa4778acca4ad0"
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