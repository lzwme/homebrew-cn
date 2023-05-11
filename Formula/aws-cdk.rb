require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.79.0.tgz"
  sha256 "a4e1997bb39ad1de383522f40cc6046f906c8d8163a676767abe3997b00e1724"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b15f0479d34ac7e2671b77d346dd217dafcedb50490404140eab3b5f8f9e0eea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b15f0479d34ac7e2671b77d346dd217dafcedb50490404140eab3b5f8f9e0eea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b15f0479d34ac7e2671b77d346dd217dafcedb50490404140eab3b5f8f9e0eea"
    sha256 cellar: :any_skip_relocation, ventura:        "594f7575df0743ef06d890a9a6c6119eb3f24180ec166fb42df5e29809bf1c4f"
    sha256 cellar: :any_skip_relocation, monterey:       "594f7575df0743ef06d890a9a6c6119eb3f24180ec166fb42df5e29809bf1c4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "594f7575df0743ef06d890a9a6c6119eb3f24180ec166fb42df5e29809bf1c4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84da2ffff9b883dbf9db1fbd6938da962805339fbddbcd61bff8646534c63d44"
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