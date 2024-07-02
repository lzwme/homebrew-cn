require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.161.tgz"
  sha256 "3090833c8d31ffd96df794c2d910ced073a795fcf59fd28736fc91a31aa217be"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "199b56a8e0d2de4489c3bbb01e6330044890b5985959f700ba0482b20185337e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "199b56a8e0d2de4489c3bbb01e6330044890b5985959f700ba0482b20185337e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199b56a8e0d2de4489c3bbb01e6330044890b5985959f700ba0482b20185337e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9103ce968ce0bc419945c337280e59530a6d9f4f044bd858f2171498f2907d31"
    sha256 cellar: :any_skip_relocation, ventura:        "9103ce968ce0bc419945c337280e59530a6d9f4f044bd858f2171498f2907d31"
    sha256 cellar: :any_skip_relocation, monterey:       "9103ce968ce0bc419945c337280e59530a6d9f4f044bd858f2171498f2907d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b01b3aaa11099be913f519c4afda06767dda3879e2bb6fad8bed477e19993e0a"
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