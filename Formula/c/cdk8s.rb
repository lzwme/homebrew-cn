require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.96.tgz"
  sha256 "fc39aa5d5c284e18ecbb643ad7765d136faff7944c221ab5870e8e9aafe210ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "256e0ac66ff798811637c1c9cabbcd77934b73b01f4b6bcd823963e018f10beb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "256e0ac66ff798811637c1c9cabbcd77934b73b01f4b6bcd823963e018f10beb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "256e0ac66ff798811637c1c9cabbcd77934b73b01f4b6bcd823963e018f10beb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7010fddfec17b8a9f2c8a4c065b3d31712cb3eaeeeae5a390020fc65fd2fa45c"
    sha256 cellar: :any_skip_relocation, ventura:        "7010fddfec17b8a9f2c8a4c065b3d31712cb3eaeeeae5a390020fc65fd2fa45c"
    sha256 cellar: :any_skip_relocation, monterey:       "7010fddfec17b8a9f2c8a4c065b3d31712cb3eaeeeae5a390020fc65fd2fa45c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "256e0ac66ff798811637c1c9cabbcd77934b73b01f4b6bcd823963e018f10beb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end