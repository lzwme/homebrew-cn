require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.195.0.tgz"
  sha256 "d32de4c27cf78a29d0b7c06e8e3c5c22d360d45b95372219794147e32669bc4d"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "107dd363cb41a966e73c652408ba8833a10249aaac846d49888145eae4f1108c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "107dd363cb41a966e73c652408ba8833a10249aaac846d49888145eae4f1108c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "107dd363cb41a966e73c652408ba8833a10249aaac846d49888145eae4f1108c"
    sha256 cellar: :any_skip_relocation, sonoma:         "eff0fdc84150ee8794093cf23e7babcfb7627a8ac6f7304ad810e97ea54a388f"
    sha256 cellar: :any_skip_relocation, ventura:        "eff0fdc84150ee8794093cf23e7babcfb7627a8ac6f7304ad810e97ea54a388f"
    sha256 cellar: :any_skip_relocation, monterey:       "eff0fdc84150ee8794093cf23e7babcfb7627a8ac6f7304ad810e97ea54a388f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "107dd363cb41a966e73c652408ba8833a10249aaac846d49888145eae4f1108c"
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