require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.90.0.tgz"
  sha256 "2d6fe8fa21c362d4bf85ec1a9b66207f9c6ebc31496a38d39c851b0ddae27a13"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3484638296afc9c764a16138c92e8b99cd1081e483035cd04b52f469952f7d2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3484638296afc9c764a16138c92e8b99cd1081e483035cd04b52f469952f7d2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3484638296afc9c764a16138c92e8b99cd1081e483035cd04b52f469952f7d2c"
    sha256 cellar: :any_skip_relocation, ventura:        "35af57b7c941a753674a738194c95ff5949dcc211e1b02fed98c78e78090d5f3"
    sha256 cellar: :any_skip_relocation, monterey:       "35af57b7c941a753674a738194c95ff5949dcc211e1b02fed98c78e78090d5f3"
    sha256 cellar: :any_skip_relocation, big_sur:        "35af57b7c941a753674a738194c95ff5949dcc211e1b02fed98c78e78090d5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3484638296afc9c764a16138c92e8b99cd1081e483035cd04b52f469952f7d2c"
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