class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.78.tgz"
  sha256 "fbfeb5f311517b9fc35c64b85dcd446795dd61c60f4dbb051e3675800a02fca8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b381b47fe6e318a45e1fe51c6d09b8c9a2247b80961617b918a651103214a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42b381b47fe6e318a45e1fe51c6d09b8c9a2247b80961617b918a651103214a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42b381b47fe6e318a45e1fe51c6d09b8c9a2247b80961617b918a651103214a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "1901ce414cbc7a96929dc11849a437f9a5e87020adf1f808ab965f4d9c07b03e"
    sha256 cellar: :any_skip_relocation, ventura:       "1901ce414cbc7a96929dc11849a437f9a5e87020adf1f808ab965f4d9c07b03e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42b381b47fe6e318a45e1fe51c6d09b8c9a2247b80961617b918a651103214a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b381b47fe6e318a45e1fe51c6d09b8c9a2247b80961617b918a651103214a7"
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