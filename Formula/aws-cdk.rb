require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.72.0.tgz"
  sha256 "3487ad57a09d07037020dad2d1dc8ce29b22c316a643f2921b3feea95cc8d5b9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67e8696748581d072e3c5ba3146f709c4987d360c823f582105861f6acb176d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67e8696748581d072e3c5ba3146f709c4987d360c823f582105861f6acb176d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67e8696748581d072e3c5ba3146f709c4987d360c823f582105861f6acb176d0"
    sha256 cellar: :any_skip_relocation, ventura:        "78a0aa74498443fbeb4aed9ca85c01bd0bfc062bc481cbe673d444d0de7493a5"
    sha256 cellar: :any_skip_relocation, monterey:       "78a0aa74498443fbeb4aed9ca85c01bd0bfc062bc481cbe673d444d0de7493a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "78a0aa74498443fbeb4aed9ca85c01bd0bfc062bc481cbe673d444d0de7493a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d6442eb7fbc17859aa5039b08c840fd6620325e0fad97c27ce6b1160603ce5"
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