require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.144.tgz"
  sha256 "2faa75c3748d846dd437c2f3ddaef3981e261847ac9e867fea1665252cf51657"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29d9d2792339ef8942fc3db22867732f51ba8dfcd3bb7724e6f62bd788cb7ff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29d9d2792339ef8942fc3db22867732f51ba8dfcd3bb7724e6f62bd788cb7ff3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29d9d2792339ef8942fc3db22867732f51ba8dfcd3bb7724e6f62bd788cb7ff3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7382f609660d86e1095463b72cb13087219a99b7c53218a65203289b6878fb84"
    sha256 cellar: :any_skip_relocation, ventura:        "7382f609660d86e1095463b72cb13087219a99b7c53218a65203289b6878fb84"
    sha256 cellar: :any_skip_relocation, monterey:       "7382f609660d86e1095463b72cb13087219a99b7c53218a65203289b6878fb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52987ee54c2fe79cd7e747e4aefc805ddec93b0b4ef08b75a2d0ae422c975a4a"
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