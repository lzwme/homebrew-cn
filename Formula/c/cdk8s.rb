class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.44.tgz"
  sha256 "2b036c758d3bb245bd328e54bd2da81b067958189832ddd0aa2da7ef99085fad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6db27c1357c4cfe74f834b9faf3765993edd724963d803b516eb5b9c9eb39010"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end