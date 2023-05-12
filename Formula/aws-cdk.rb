require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.79.1.tgz"
  sha256 "f1c1ce4a651d1a3489f572b11c9b245c9fc31e56634bf08569ac526fb547a7cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32b6c87689bf4d0813a02f8affe534eafb6c11396f723576582617a0ae798a63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32b6c87689bf4d0813a02f8affe534eafb6c11396f723576582617a0ae798a63"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32b6c87689bf4d0813a02f8affe534eafb6c11396f723576582617a0ae798a63"
    sha256 cellar: :any_skip_relocation, ventura:        "42bb7ea5b375e1f9a9ea406cb7927507ed37287c25caa42c6dca151574223acc"
    sha256 cellar: :any_skip_relocation, monterey:       "42bb7ea5b375e1f9a9ea406cb7927507ed37287c25caa42c6dca151574223acc"
    sha256 cellar: :any_skip_relocation, big_sur:        "42bb7ea5b375e1f9a9ea406cb7927507ed37287c25caa42c6dca151574223acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a353fa0d9f4d5640722ebc251fb646fd4beb7b9e55f3c4a369c9925c114078fb"
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