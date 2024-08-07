class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.181.tgz"
  sha256 "a25457cc355b6d61dab8122d7128920e68f0c87046f7cd623b1425d7e1944301"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d04530a978adcfeebf82ae37650ab8f6700144752e72fe6930bc792bb321ef28"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d04530a978adcfeebf82ae37650ab8f6700144752e72fe6930bc792bb321ef28"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d04530a978adcfeebf82ae37650ab8f6700144752e72fe6930bc792bb321ef28"
    sha256 cellar: :any_skip_relocation, sonoma:         "6fd379e64d156e585d958f69e0a53f0e5db4e51b4ad485bb079804376684469b"
    sha256 cellar: :any_skip_relocation, ventura:        "6fd379e64d156e585d958f69e0a53f0e5db4e51b4ad485bb079804376684469b"
    sha256 cellar: :any_skip_relocation, monterey:       "6fd379e64d156e585d958f69e0a53f0e5db4e51b4ad485bb079804376684469b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d04530a978adcfeebf82ae37650ab8f6700144752e72fe6930bc792bb321ef28"
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