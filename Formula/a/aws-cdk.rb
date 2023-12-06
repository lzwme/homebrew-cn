require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.114.0.tgz"
  sha256 "4f4bb04e46e86a3ceef605f6237a0617809bbf6e1226b40107ce8db1188b43b5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3ed3179a2e4ec2eb8b789b2bf9df3832f4fa42e75ebf706c8e60163ab63736ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ed3179a2e4ec2eb8b789b2bf9df3832f4fa42e75ebf706c8e60163ab63736ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ed3179a2e4ec2eb8b789b2bf9df3832f4fa42e75ebf706c8e60163ab63736ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "030825f97a6584797fd10702c1147bfc314ce498410655efa3de47aceb0b74f0"
    sha256 cellar: :any_skip_relocation, ventura:        "030825f97a6584797fd10702c1147bfc314ce498410655efa3de47aceb0b74f0"
    sha256 cellar: :any_skip_relocation, monterey:       "030825f97a6584797fd10702c1147bfc314ce498410655efa3de47aceb0b74f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ab942f1405e68223ed0d3ccf80f21b9dfacd956b06cb9cbb6c2cd0ad28856e2"
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