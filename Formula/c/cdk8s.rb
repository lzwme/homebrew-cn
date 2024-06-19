require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.149.tgz"
  sha256 "99d96a4feafe88aaa50d9e3fc7ce3d630237d558ec6cbc222af12c07ae77940d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7bec3041265b74655634df6d86d65420cc6d2c80f04787afff11096406fc996"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7bec3041265b74655634df6d86d65420cc6d2c80f04787afff11096406fc996"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7bec3041265b74655634df6d86d65420cc6d2c80f04787afff11096406fc996"
    sha256 cellar: :any_skip_relocation, sonoma:         "0c9fc0720f73dbdc7fb142e6f07b325d572101156832259021433b869431219e"
    sha256 cellar: :any_skip_relocation, ventura:        "0c9fc0720f73dbdc7fb142e6f07b325d572101156832259021433b869431219e"
    sha256 cellar: :any_skip_relocation, monterey:       "654544c4cfccfdd880792eadfa406839dd09cc1d1851b45eb59db33261788b4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55771e747b36993d811734bdf5a3f7ed793d8694e80692db11c7365fdef14c66"
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