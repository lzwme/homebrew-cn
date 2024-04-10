require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.95.tgz"
  sha256 "be952a290cfa35939e35a4278facca2130098a906f8902d22fe9a96608ca8103"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93673d5a3cb61c30c887a6017a66f056a43a28ef56b8791a1193658e11f2cc65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93673d5a3cb61c30c887a6017a66f056a43a28ef56b8791a1193658e11f2cc65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93673d5a3cb61c30c887a6017a66f056a43a28ef56b8791a1193658e11f2cc65"
    sha256 cellar: :any_skip_relocation, sonoma:         "12cc56debe062bd9fcc3e80f3dc48e679fc892449e97ccf696f1c12bce362622"
    sha256 cellar: :any_skip_relocation, ventura:        "12cc56debe062bd9fcc3e80f3dc48e679fc892449e97ccf696f1c12bce362622"
    sha256 cellar: :any_skip_relocation, monterey:       "12cc56debe062bd9fcc3e80f3dc48e679fc892449e97ccf696f1c12bce362622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93673d5a3cb61c30c887a6017a66f056a43a28ef56b8791a1193658e11f2cc65"
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