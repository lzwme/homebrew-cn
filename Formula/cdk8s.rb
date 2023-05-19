require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.36.tgz"
  sha256 "867bf04613eed376b05ff684b64f67bb84fdf0bc8a7c282a4b22ab1bfb9eb338"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0d78f92e85535aea08c1c861c28570a4424d43ea9774978b9e1d4c0bb60fdb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0d78f92e85535aea08c1c861c28570a4424d43ea9774978b9e1d4c0bb60fdb7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0d78f92e85535aea08c1c861c28570a4424d43ea9774978b9e1d4c0bb60fdb7"
    sha256 cellar: :any_skip_relocation, ventura:        "268467bb3d1b4c2616c9792a930463f09b02b74a9319957b55ecd8d782ed8d59"
    sha256 cellar: :any_skip_relocation, monterey:       "268467bb3d1b4c2616c9792a930463f09b02b74a9319957b55ecd8d782ed8d59"
    sha256 cellar: :any_skip_relocation, big_sur:        "268467bb3d1b4c2616c9792a930463f09b02b74a9319957b55ecd8d782ed8d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0d78f92e85535aea08c1c861c28570a4424d43ea9774978b9e1d4c0bb60fdb7"
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