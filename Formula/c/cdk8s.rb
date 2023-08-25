require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.56.0.tgz"
  sha256 "d9cea9570bd3600ca7802cddfc5750b469b01b9e9db510da8c7e087b69901921"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60d6552417ab883d84ac8336d5bf4a4a4f1a427316b4cc988a1215fe6eacf1e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60d6552417ab883d84ac8336d5bf4a4a4f1a427316b4cc988a1215fe6eacf1e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60d6552417ab883d84ac8336d5bf4a4a4f1a427316b4cc988a1215fe6eacf1e7"
    sha256 cellar: :any_skip_relocation, ventura:        "2ee130c508dfc8fbd50e5a9ccb62c0663808c6ea2d8d02315e5a35236f1526fa"
    sha256 cellar: :any_skip_relocation, monterey:       "2ee130c508dfc8fbd50e5a9ccb62c0663808c6ea2d8d02315e5a35236f1526fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ee130c508dfc8fbd50e5a9ccb62c0663808c6ea2d8d02315e5a35236f1526fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d6552417ab883d84ac8336d5bf4a4a4f1a427316b4cc988a1215fe6eacf1e7"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end