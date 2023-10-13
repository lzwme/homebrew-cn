require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.136.0.tgz"
  sha256 "7ec2af4b537f365b10d417e3b8dee6899a4dc649e5bfc31afbfdda2ee8c2c2ea"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9fa7153043a5e3d920f1f9a3de01e5c6dc1dee8d561c1ce7420dbe19bdf4559f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fa7153043a5e3d920f1f9a3de01e5c6dc1dee8d561c1ce7420dbe19bdf4559f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fa7153043a5e3d920f1f9a3de01e5c6dc1dee8d561c1ce7420dbe19bdf4559f"
    sha256 cellar: :any_skip_relocation, sonoma:         "f2eb93b041381f8e935b2d5e2b58cd2ccac169e5000fe74990f587dbf77742e7"
    sha256 cellar: :any_skip_relocation, ventura:        "f2eb93b041381f8e935b2d5e2b58cd2ccac169e5000fe74990f587dbf77742e7"
    sha256 cellar: :any_skip_relocation, monterey:       "f2eb93b041381f8e935b2d5e2b58cd2ccac169e5000fe74990f587dbf77742e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fa7153043a5e3d920f1f9a3de01e5c6dc1dee8d561c1ce7420dbe19bdf4559f"
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