require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.75.1.tgz"
  sha256 "5be5344e1da3395f028436df79a9791c8ac1b66242482b1b0926a0252b441379"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6e9de8ab7fbd0846c66e0bdf63581612f3402fb97c0f5c38c0bbe808fddbe58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6e9de8ab7fbd0846c66e0bdf63581612f3402fb97c0f5c38c0bbe808fddbe58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6e9de8ab7fbd0846c66e0bdf63581612f3402fb97c0f5c38c0bbe808fddbe58"
    sha256 cellar: :any_skip_relocation, ventura:        "723c52da9c35a0f754ec85741ebc47baa3b603a1b85a866a9f344b4f55de780c"
    sha256 cellar: :any_skip_relocation, monterey:       "723c52da9c35a0f754ec85741ebc47baa3b603a1b85a866a9f344b4f55de780c"
    sha256 cellar: :any_skip_relocation, big_sur:        "723c52da9c35a0f754ec85741ebc47baa3b603a1b85a866a9f344b4f55de780c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c38cd511b337cefee503fcf886b2a34e7310b2bad81835a9466f7170166891d"
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