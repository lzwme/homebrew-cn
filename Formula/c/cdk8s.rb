class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.42.tgz"
  sha256 "8f8e9c5caf8000e3dcc2d0200e9ec59fdbba6f785ad20dc35499b1245c2c40f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f556e2020fd67e410e6526a72f724d2430fea45f8769aff9e32eb0ee02ac2a5e"
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