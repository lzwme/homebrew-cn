require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.113.0.tgz"
  sha256 "5f136a6b0ec6ab721ea52c22a856f919fc6732325b7a59dc8843a439d7b294eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "183ee68db1b4360b588528429099445ffef6f243dab2d0e1af1424f54c68a659"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "183ee68db1b4360b588528429099445ffef6f243dab2d0e1af1424f54c68a659"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "183ee68db1b4360b588528429099445ffef6f243dab2d0e1af1424f54c68a659"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae454261689ab372ba1e0d8d5311fa10c3bbdd0cacd3652145899b605954c94c"
    sha256 cellar: :any_skip_relocation, ventura:        "ae454261689ab372ba1e0d8d5311fa10c3bbdd0cacd3652145899b605954c94c"
    sha256 cellar: :any_skip_relocation, monterey:       "ae454261689ab372ba1e0d8d5311fa10c3bbdd0cacd3652145899b605954c94c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff6aaf6f4f107e2fdf4eacf55f862ae8f9772041896bcb3dfff760e7cb074163"
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