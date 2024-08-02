class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.176.tgz"
  sha256 "e49c2d8ac85b6af57b717006370b2f3eaba65a80a5c071f45f9ffe6fddd5b1d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e218140db668d25a75f72964b6ead312859d8abf0114d73bd7173d6b6e0a32f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e218140db668d25a75f72964b6ead312859d8abf0114d73bd7173d6b6e0a32f9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e218140db668d25a75f72964b6ead312859d8abf0114d73bd7173d6b6e0a32f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "efb7e67a617419d268f4735016397525a2b62723ecfd896f2e0d0a1273f88a7b"
    sha256 cellar: :any_skip_relocation, ventura:        "efb7e67a617419d268f4735016397525a2b62723ecfd896f2e0d0a1273f88a7b"
    sha256 cellar: :any_skip_relocation, monterey:       "efb7e67a617419d268f4735016397525a2b62723ecfd896f2e0d0a1273f88a7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e9d3d549422e22eabdef2d26f9e85851cf2cb1898f3a098bbec8b3eef109ecd"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end