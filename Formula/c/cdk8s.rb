require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.26.tgz"
  sha256 "b619581a42f07071e45b58c4d9b600beb45b1001aa47926480f74bccd42b82bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "255262cb6e326de0b99890c9cfb51cc03d017fa25afc939c152356757c8dafc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "255262cb6e326de0b99890c9cfb51cc03d017fa25afc939c152356757c8dafc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "255262cb6e326de0b99890c9cfb51cc03d017fa25afc939c152356757c8dafc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "83c7be19243fd68dd58c8ac4590ba38ca9c50de9d0d7ef753b024ebe232619c6"
    sha256 cellar: :any_skip_relocation, ventura:        "83c7be19243fd68dd58c8ac4590ba38ca9c50de9d0d7ef753b024ebe232619c6"
    sha256 cellar: :any_skip_relocation, monterey:       "83c7be19243fd68dd58c8ac4590ba38ca9c50de9d0d7ef753b024ebe232619c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255262cb6e326de0b99890c9cfb51cc03d017fa25afc939c152356757c8dafc0"
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