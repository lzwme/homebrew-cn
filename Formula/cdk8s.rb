require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.115.tgz"
  sha256 "c56da149ef970e7efc6617fa7390fec13bcbe497beefca5f8a53f1ff7c0a6c17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5130e02747680cfd88f25fcf42c8ae64bd9159c7231f3a845aabb70a65e509b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5130e02747680cfd88f25fcf42c8ae64bd9159c7231f3a845aabb70a65e509b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5130e02747680cfd88f25fcf42c8ae64bd9159c7231f3a845aabb70a65e509b1"
    sha256 cellar: :any_skip_relocation, ventura:        "7923dda58ed3c24c94fa78d026fef2bdeef24cfeca411d73e65703e3c336056b"
    sha256 cellar: :any_skip_relocation, monterey:       "7923dda58ed3c24c94fa78d026fef2bdeef24cfeca411d73e65703e3c336056b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7923dda58ed3c24c94fa78d026fef2bdeef24cfeca411d73e65703e3c336056b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5130e02747680cfd88f25fcf42c8ae64bd9159c7231f3a845aabb70a65e509b1"
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