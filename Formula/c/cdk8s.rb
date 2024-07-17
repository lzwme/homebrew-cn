require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.174.tgz"
  sha256 "fa4bb59bfdcba5723e8e317b4a36f78ea48ee29a4f0990f7ac4bf15b64149c89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df7e0338ecedc65fe252876491b52735d55f0fd2aa9f261a1c022581340a7954"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df7e0338ecedc65fe252876491b52735d55f0fd2aa9f261a1c022581340a7954"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df7e0338ecedc65fe252876491b52735d55f0fd2aa9f261a1c022581340a7954"
    sha256 cellar: :any_skip_relocation, sonoma:         "6673d88481a6cf07d244fdf0391edb8a34df215b06caf8047bc67e578bb70a48"
    sha256 cellar: :any_skip_relocation, ventura:        "6673d88481a6cf07d244fdf0391edb8a34df215b06caf8047bc67e578bb70a48"
    sha256 cellar: :any_skip_relocation, monterey:       "6673d88481a6cf07d244fdf0391edb8a34df215b06caf8047bc67e578bb70a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9829b243a7dee3fe48e3cad1ecf57ccacabbecaad4bd6c8ddb9c2df7e1d362b3"
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