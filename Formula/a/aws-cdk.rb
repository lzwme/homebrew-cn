require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.114.1.tgz"
  sha256 "6eaad26f51c9afa5433f42b2ed4073affcb74b6e692a11316f24c7acbbc821b4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4458cad18fbdd8842a3111cc6ed2892c67f164cd8b58c78928f0977a5d531b25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4458cad18fbdd8842a3111cc6ed2892c67f164cd8b58c78928f0977a5d531b25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4458cad18fbdd8842a3111cc6ed2892c67f164cd8b58c78928f0977a5d531b25"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee45b85dba91e5adda6a7595c875235617718753a5cbf0da945fc363ddd88d58"
    sha256 cellar: :any_skip_relocation, ventura:        "ee45b85dba91e5adda6a7595c875235617718753a5cbf0da945fc363ddd88d58"
    sha256 cellar: :any_skip_relocation, monterey:       "ee45b85dba91e5adda6a7595c875235617718753a5cbf0da945fc363ddd88d58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cac5183eb3deb114a5e0f837275b541aef5d246c2c0939a53b796774433d2709"
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