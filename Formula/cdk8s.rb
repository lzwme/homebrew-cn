require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.96.tgz"
  sha256 "1acd58d895f313911d3655aa88460abea7a1c529ef4abc5108143d5acf5be76e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11e68eea092876bf674d572bfd75c24cdc9981fab8e10ddb688b284515de280b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11e68eea092876bf674d572bfd75c24cdc9981fab8e10ddb688b284515de280b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11e68eea092876bf674d572bfd75c24cdc9981fab8e10ddb688b284515de280b"
    sha256 cellar: :any_skip_relocation, ventura:        "8d88164e102d23130e8d352334755332da6e3352a9909658d2b39414f9ceab12"
    sha256 cellar: :any_skip_relocation, monterey:       "8d88164e102d23130e8d352334755332da6e3352a9909658d2b39414f9ceab12"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d88164e102d23130e8d352334755332da6e3352a9909658d2b39414f9ceab12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e68eea092876bf674d572bfd75c24cdc9981fab8e10ddb688b284515de280b"
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