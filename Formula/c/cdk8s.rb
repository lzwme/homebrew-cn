require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.8.tgz"
  sha256 "367ca4ea975dc0bc4985dda24f8d2a71561fb0b9077ca7941e168c79d0908ba2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a48cc5b21030d9ee921356b49c4b9903c02de292f948901ed59ea15a2ed93d53"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a48cc5b21030d9ee921356b49c4b9903c02de292f948901ed59ea15a2ed93d53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a48cc5b21030d9ee921356b49c4b9903c02de292f948901ed59ea15a2ed93d53"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a5b89c7c958324f95a8e442a5d6a39e6d4e162b5cc9d9170cb34d4e994425f6"
    sha256 cellar: :any_skip_relocation, ventura:        "8a5b89c7c958324f95a8e442a5d6a39e6d4e162b5cc9d9170cb34d4e994425f6"
    sha256 cellar: :any_skip_relocation, monterey:       "8a5b89c7c958324f95a8e442a5d6a39e6d4e162b5cc9d9170cb34d4e994425f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a48cc5b21030d9ee921356b49c4b9903c02de292f948901ed59ea15a2ed93d53"
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