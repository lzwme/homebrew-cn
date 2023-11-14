require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.107.0.tgz"
  sha256 "db475e60de5ccd11c8c56f8babf863f6916470c7ba0933e92bd875d0f3a73062"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03ccaa229009227a1d24b6d7b6cb103b65a49445f6e857b5f07e114acd67a52a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03ccaa229009227a1d24b6d7b6cb103b65a49445f6e857b5f07e114acd67a52a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03ccaa229009227a1d24b6d7b6cb103b65a49445f6e857b5f07e114acd67a52a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4cbaee0cee83e9a29e2806fcf8c1ee54535e46f4cc32cd7778918420f7b4163"
    sha256 cellar: :any_skip_relocation, ventura:        "c4cbaee0cee83e9a29e2806fcf8c1ee54535e46f4cc32cd7778918420f7b4163"
    sha256 cellar: :any_skip_relocation, monterey:       "c4cbaee0cee83e9a29e2806fcf8c1ee54535e46f4cc32cd7778918420f7b4163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a063fdb6895077f823b1540a9fe73d6ca0fd348e4a606277badcdc470c9de6b"
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