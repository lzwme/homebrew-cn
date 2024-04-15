require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.99.tgz"
  sha256 "42e310966e061493d9caed284c372c20dcbfc48057b32e15f7c6847d4a2ebb15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfa44ecf9d59706760d9e61dbe415bd66cb14d4e3a7572705f42d10e1e7c549a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dfa44ecf9d59706760d9e61dbe415bd66cb14d4e3a7572705f42d10e1e7c549a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfa44ecf9d59706760d9e61dbe415bd66cb14d4e3a7572705f42d10e1e7c549a"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6109ff1399099cf41c685c519f510b2ccdd5dad2bf97114a0a16923a639c59e"
    sha256 cellar: :any_skip_relocation, ventura:        "e6109ff1399099cf41c685c519f510b2ccdd5dad2bf97114a0a16923a639c59e"
    sha256 cellar: :any_skip_relocation, monterey:       "e6109ff1399099cf41c685c519f510b2ccdd5dad2bf97114a0a16923a639c59e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa44ecf9d59706760d9e61dbe415bd66cb14d4e3a7572705f42d10e1e7c549a"
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