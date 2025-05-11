class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.66.tgz"
  sha256 "97c21346efae05e1b7d8cd1472953ab1ad6cdca8e3ec2451787edec20913f3e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "147a7e20740ab649da4fa7478a4c2fae9b11eca085c9c883edea2a5a730252ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "147a7e20740ab649da4fa7478a4c2fae9b11eca085c9c883edea2a5a730252ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "147a7e20740ab649da4fa7478a4c2fae9b11eca085c9c883edea2a5a730252ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ba5542fe1169e0e2cc08179ffd43917f3e5926064fee9fafa3f3c16fb44df36"
    sha256 cellar: :any_skip_relocation, ventura:       "9ba5542fe1169e0e2cc08179ffd43917f3e5926064fee9fafa3f3c16fb44df36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "147a7e20740ab649da4fa7478a4c2fae9b11eca085c9c883edea2a5a730252ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "147a7e20740ab649da4fa7478a4c2fae9b11eca085c9c883edea2a5a730252ac"
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