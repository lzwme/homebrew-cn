require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.182.0.tgz"
  sha256 "38242b599b803d710936625973beca1eff91f16c0cab5aca85ad064b51b21811"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d17a0df08fb54c02e1e0b75bec36b8844d49351d7aae9a787fb84d4faf1fddda"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d17a0df08fb54c02e1e0b75bec36b8844d49351d7aae9a787fb84d4faf1fddda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d17a0df08fb54c02e1e0b75bec36b8844d49351d7aae9a787fb84d4faf1fddda"
    sha256 cellar: :any_skip_relocation, sonoma:         "4276e2517120a2f215f9dfb4ff4dd402a8326c73887b5680828c78c5b70b5435"
    sha256 cellar: :any_skip_relocation, ventura:        "4276e2517120a2f215f9dfb4ff4dd402a8326c73887b5680828c78c5b70b5435"
    sha256 cellar: :any_skip_relocation, monterey:       "4276e2517120a2f215f9dfb4ff4dd402a8326c73887b5680828c78c5b70b5435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d17a0df08fb54c02e1e0b75bec36b8844d49351d7aae9a787fb84d4faf1fddda"
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