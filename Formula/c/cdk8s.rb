require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.52.0.tgz"
  sha256 "64a0f36313126d513effed8f2110ccd9c15e566ae7542592f902fdafd927f9ba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "169d5885b2eccde9b5ce41d0b288cad77115ba4729d86181982674ed88e60b70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "169d5885b2eccde9b5ce41d0b288cad77115ba4729d86181982674ed88e60b70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "169d5885b2eccde9b5ce41d0b288cad77115ba4729d86181982674ed88e60b70"
    sha256 cellar: :any_skip_relocation, ventura:        "b98309b9b2215fbca23c18c8a3e4730bd53c0decc66ce4cc15c4382f498860b4"
    sha256 cellar: :any_skip_relocation, monterey:       "b98309b9b2215fbca23c18c8a3e4730bd53c0decc66ce4cc15c4382f498860b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b98309b9b2215fbca23c18c8a3e4730bd53c0decc66ce4cc15c4382f498860b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "169d5885b2eccde9b5ce41d0b288cad77115ba4729d86181982674ed88e60b70"
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