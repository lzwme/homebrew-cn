class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.207.57.tgz"
  sha256 "c6f3a1a04a5b0e7249645c96fdee353d42cba565d39da870d59bf3f0b335ece4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a4d488ad0932a21f2a22eb336c349454bc449ccf194aa7cb24486c4c459f18bb"
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