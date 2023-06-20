require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.66.tgz"
  sha256 "528b8da94ad0ff4c1a4c9e2956597018cdae60e1ebae3e31cafd5429e20b392a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d21107af2e3bd160c1658622fd40f6ddf50760265a1a8e5339e6e4ae2c995b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d21107af2e3bd160c1658622fd40f6ddf50760265a1a8e5339e6e4ae2c995b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d21107af2e3bd160c1658622fd40f6ddf50760265a1a8e5339e6e4ae2c995b2"
    sha256 cellar: :any_skip_relocation, ventura:        "91cce004c53f4c8710c8fd7d6200519b1b8fdaccaee6713b929dff778886772f"
    sha256 cellar: :any_skip_relocation, monterey:       "91cce004c53f4c8710c8fd7d6200519b1b8fdaccaee6713b929dff778886772f"
    sha256 cellar: :any_skip_relocation, big_sur:        "91cce004c53f4c8710c8fd7d6200519b1b8fdaccaee6713b929dff778886772f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d21107af2e3bd160c1658622fd40f6ddf50760265a1a8e5339e6e4ae2c995b2"
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