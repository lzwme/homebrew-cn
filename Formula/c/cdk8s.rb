class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.125.tgz"
  sha256 "fe01c50aa81aea77e6e72ec6c64f802b2a1c4ee07572f7a0f6540b24fb8fcee6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "738a3fc7c2f8c6355bd7bf30bc4cc3725cedb23d1a68726fca4e040742830cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "738a3fc7c2f8c6355bd7bf30bc4cc3725cedb23d1a68726fca4e040742830cd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "738a3fc7c2f8c6355bd7bf30bc4cc3725cedb23d1a68726fca4e040742830cd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "57917b9866e8d50814010886afc0fac14d436cc4af0b8db129a02e38844da759"
    sha256 cellar: :any_skip_relocation, ventura:       "57917b9866e8d50814010886afc0fac14d436cc4af0b8db129a02e38844da759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "738a3fc7c2f8c6355bd7bf30bc4cc3725cedb23d1a68726fca4e040742830cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "738a3fc7c2f8c6355bd7bf30bc4cc3725cedb23d1a68726fca4e040742830cd7"
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