class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.68.tgz"
  sha256 "10273961f950124d486b5c8978b8fded8bf8e8667439a13898766ebdad6df7a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ffea2a696d1e2bec65e31da0b292c5eeb422c459f2fa8d9e37552859afb4c67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ffea2a696d1e2bec65e31da0b292c5eeb422c459f2fa8d9e37552859afb4c67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3ffea2a696d1e2bec65e31da0b292c5eeb422c459f2fa8d9e37552859afb4c67"
    sha256 cellar: :any_skip_relocation, sonoma:        "07de0b34f28b60970f8b6b1539b75bccbc2a562dbb94be4c956ce1642db20623"
    sha256 cellar: :any_skip_relocation, ventura:       "07de0b34f28b60970f8b6b1539b75bccbc2a562dbb94be4c956ce1642db20623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ffea2a696d1e2bec65e31da0b292c5eeb422c459f2fa8d9e37552859afb4c67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ffea2a696d1e2bec65e31da0b292c5eeb422c459f2fa8d9e37552859afb4c67"
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