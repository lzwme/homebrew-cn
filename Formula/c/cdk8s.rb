class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.201.33.tgz"
  sha256 "111c5ffdaa5657f8281f64a36ead2624e01b9758b60f9d1e35361a11f15389ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8e9cd35f75c800f16d4d6716a3047923df6dcd42142529add86c8af9545696b7"
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