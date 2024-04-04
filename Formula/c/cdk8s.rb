require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.91.tgz"
  sha256 "af1ddab943583b8f90ebf9e98be4491856f14c1bdd84cd3fe469271ff95a9309"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df68106f387e4c9700ec502d58b310c07573fb555bb0d0693aff6fe754535ad6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df68106f387e4c9700ec502d58b310c07573fb555bb0d0693aff6fe754535ad6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df68106f387e4c9700ec502d58b310c07573fb555bb0d0693aff6fe754535ad6"
    sha256 cellar: :any_skip_relocation, sonoma:         "a25e2902e8c69633fa71be25a41ac01c96f73ce5a586ed8cb6187c3df39d5ad4"
    sha256 cellar: :any_skip_relocation, ventura:        "a25e2902e8c69633fa71be25a41ac01c96f73ce5a586ed8cb6187c3df39d5ad4"
    sha256 cellar: :any_skip_relocation, monterey:       "a25e2902e8c69633fa71be25a41ac01c96f73ce5a586ed8cb6187c3df39d5ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df68106f387e4c9700ec502d58b310c07573fb555bb0d0693aff6fe754535ad6"
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