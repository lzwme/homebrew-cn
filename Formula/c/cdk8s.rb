require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.171.0.tgz"
  sha256 "c3a6be2e317cc77579328acd4cbc79e2d7c4884c1830e1f85b0f348404613794"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9501afb6c4f7ad00c629b328e9f1cba90202dd9b12733447cedec01d95897f6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9501afb6c4f7ad00c629b328e9f1cba90202dd9b12733447cedec01d95897f6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9501afb6c4f7ad00c629b328e9f1cba90202dd9b12733447cedec01d95897f6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "adaee625f47c31c4c2efd01aa2ee076b14c4517f91bc2a7260af9bdaf60d8425"
    sha256 cellar: :any_skip_relocation, ventura:        "adaee625f47c31c4c2efd01aa2ee076b14c4517f91bc2a7260af9bdaf60d8425"
    sha256 cellar: :any_skip_relocation, monterey:       "adaee625f47c31c4c2efd01aa2ee076b14c4517f91bc2a7260af9bdaf60d8425"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9501afb6c4f7ad00c629b328e9f1cba90202dd9b12733447cedec01d95897f6a"
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