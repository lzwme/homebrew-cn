class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.195.tgz"
  sha256 "326e367ee248717bba58821de7977b85b603458b1e37d4a392e826d0b62d3009"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bfc805efceceea20306c5648f6bd4f1865e05cff8719feeba1561664d55a876b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfc805efceceea20306c5648f6bd4f1865e05cff8719feeba1561664d55a876b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfc805efceceea20306c5648f6bd4f1865e05cff8719feeba1561664d55a876b"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf85bc5c66c4074a84b3190dce8909c752342264fa4664f74c83420494ec1ab5"
    sha256 cellar: :any_skip_relocation, ventura:        "bf85bc5c66c4074a84b3190dce8909c752342264fa4664f74c83420494ec1ab5"
    sha256 cellar: :any_skip_relocation, monterey:       "bf85bc5c66c4074a84b3190dce8909c752342264fa4664f74c83420494ec1ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfc805efceceea20306c5648f6bd4f1865e05cff8719feeba1561664d55a876b"
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