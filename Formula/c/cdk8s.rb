require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.155.tgz"
  sha256 "967d8de1f738b7e56b3b3733ae4c531d311e70333dfa31d7266cece6c326ee09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d78b50357facc1e11a03725b675b9ecf622ede71b0da4dd482cbd8801280153"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d78b50357facc1e11a03725b675b9ecf622ede71b0da4dd482cbd8801280153"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d78b50357facc1e11a03725b675b9ecf622ede71b0da4dd482cbd8801280153"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa1ed9d74ec74f52a0a6d4f3bd80707aa59cc80a3f3c1fa5e97600bfa03b8374"
    sha256 cellar: :any_skip_relocation, ventura:        "fa1ed9d74ec74f52a0a6d4f3bd80707aa59cc80a3f3c1fa5e97600bfa03b8374"
    sha256 cellar: :any_skip_relocation, monterey:       "fa1ed9d74ec74f52a0a6d4f3bd80707aa59cc80a3f3c1fa5e97600bfa03b8374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd52698b457800b498c12c6b0db8e913d54ecbda2b961f1e67ba4b17e30b021b"
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