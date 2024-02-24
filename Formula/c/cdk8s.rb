require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.55.tgz"
  sha256 "01aaee343372981ac5d91af35cf2331b584eef22dded4c406c52e9f48448ef62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fb5907657b7ef1baa1722886a053df1e5e093cef6aa869d540f59e3460c13166"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb5907657b7ef1baa1722886a053df1e5e093cef6aa869d540f59e3460c13166"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5907657b7ef1baa1722886a053df1e5e093cef6aa869d540f59e3460c13166"
    sha256 cellar: :any_skip_relocation, sonoma:         "c68d204291a080608fbc0451a276ff92c0ef02d8b8eeba9ce4711ca84915aef2"
    sha256 cellar: :any_skip_relocation, ventura:        "c68d204291a080608fbc0451a276ff92c0ef02d8b8eeba9ce4711ca84915aef2"
    sha256 cellar: :any_skip_relocation, monterey:       "c68d204291a080608fbc0451a276ff92c0ef02d8b8eeba9ce4711ca84915aef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb5907657b7ef1baa1722886a053df1e5e093cef6aa869d540f59e3460c13166"
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