require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.95.0.tgz"
  sha256 "7e26135f787cc0b26d198d039d8af56fbc939b6a8d465fb68c45f80b02aa8636"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9695dbf43e7c5c8dc9689ee656e85682bb01998424794b06540081308fdebf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9695dbf43e7c5c8dc9689ee656e85682bb01998424794b06540081308fdebf0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9695dbf43e7c5c8dc9689ee656e85682bb01998424794b06540081308fdebf0"
    sha256 cellar: :any_skip_relocation, ventura:        "98437ee095bc13066c2458d21fcc66a97e36f0378e1816616c23577355c4a1a7"
    sha256 cellar: :any_skip_relocation, monterey:       "98437ee095bc13066c2458d21fcc66a97e36f0378e1816616c23577355c4a1a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "98437ee095bc13066c2458d21fcc66a97e36f0378e1816616c23577355c4a1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "895982f296546f2aca8b5e35b1c1239f66172aaecfae98b4c8524af6efe11afc"
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