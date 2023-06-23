require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.70.tgz"
  sha256 "1ce5a97e11738dcdf45e0b8acef9e483eecb8219a448f547a3a67837060050f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7af075eaa7b478dbf74108bc3eaeef2afb3dfcf1df18ac956cb755c7e009af6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7af075eaa7b478dbf74108bc3eaeef2afb3dfcf1df18ac956cb755c7e009af6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7af075eaa7b478dbf74108bc3eaeef2afb3dfcf1df18ac956cb755c7e009af6"
    sha256 cellar: :any_skip_relocation, ventura:        "aa62e75ebba3e19fb70a009e8f84be1c96edce8657a8305d77bb5340937cdf86"
    sha256 cellar: :any_skip_relocation, monterey:       "aa62e75ebba3e19fb70a009e8f84be1c96edce8657a8305d77bb5340937cdf86"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa62e75ebba3e19fb70a009e8f84be1c96edce8657a8305d77bb5340937cdf86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7af075eaa7b478dbf74108bc3eaeef2afb3dfcf1df18ac956cb755c7e009af6"
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