class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.203.tgz"
  sha256 "bc0885035166a38079ae846024286a62d20000997a8def1567c78600aed4e36e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e83c3394bff1edf4e711efb48908c1aed0a52c9ec6fee3764442724c199f7a1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e83c3394bff1edf4e711efb48908c1aed0a52c9ec6fee3764442724c199f7a1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e83c3394bff1edf4e711efb48908c1aed0a52c9ec6fee3764442724c199f7a1b"
    sha256 cellar: :any_skip_relocation, sonoma:         "24a02076e562baa085b80f2879b17603e87226097ac49a2069c717b493edbe4a"
    sha256 cellar: :any_skip_relocation, ventura:        "24a02076e562baa085b80f2879b17603e87226097ac49a2069c717b493edbe4a"
    sha256 cellar: :any_skip_relocation, monterey:       "24a02076e562baa085b80f2879b17603e87226097ac49a2069c717b493edbe4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e83c3394bff1edf4e711efb48908c1aed0a52c9ec6fee3764442724c199f7a1b"
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