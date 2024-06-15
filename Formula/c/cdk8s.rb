require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.145.tgz"
  sha256 "5613f8eca779204edac3d1daaedc0def5ab759ca65653a0c5215eb29ee0b75c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f956ca6d74c9e9551a27006a2c20f51cdd6c86274e0bbf11733df5727fefccb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f956ca6d74c9e9551a27006a2c20f51cdd6c86274e0bbf11733df5727fefccb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f956ca6d74c9e9551a27006a2c20f51cdd6c86274e0bbf11733df5727fefccb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f262d380dd571e1bca829dcc040386d358dbff00455934e803a167d15010130d"
    sha256 cellar: :any_skip_relocation, ventura:        "f262d380dd571e1bca829dcc040386d358dbff00455934e803a167d15010130d"
    sha256 cellar: :any_skip_relocation, monterey:       "f262d380dd571e1bca829dcc040386d358dbff00455934e803a167d15010130d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26c0cb90b6b7d44606c6db1fb01a48cd8773961550757bd7852cd5b65301b692"
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