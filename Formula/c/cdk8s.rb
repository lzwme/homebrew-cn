require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.29.tgz"
  sha256 "20ef69774a50747dd83c9bdd51ee12d6a9cb8337ffe9c271defcb875ba3ac31c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a7a31d757d52f7526357c529879bef1d1aa245653b0361058cd37a0f3155f5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a7a31d757d52f7526357c529879bef1d1aa245653b0361058cd37a0f3155f5e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a7a31d757d52f7526357c529879bef1d1aa245653b0361058cd37a0f3155f5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "79eaa6bf18b74c69f341e129511f90b1ae2181dda42ad15b5c79195f7d337edc"
    sha256 cellar: :any_skip_relocation, ventura:        "79eaa6bf18b74c69f341e129511f90b1ae2181dda42ad15b5c79195f7d337edc"
    sha256 cellar: :any_skip_relocation, monterey:       "79eaa6bf18b74c69f341e129511f90b1ae2181dda42ad15b5c79195f7d337edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a7a31d757d52f7526357c529879bef1d1aa245653b0361058cd37a0f3155f5e"
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