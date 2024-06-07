require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.138.tgz"
  sha256 "05ef53cab3b9df0e7cf971e9e69cc43a1022e20c20607557477c150a89293aa0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "71348592eaef8b5923aa9d4653a11d70876b41cb41537bf2f4b8dd1ed054eb97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71348592eaef8b5923aa9d4653a11d70876b41cb41537bf2f4b8dd1ed054eb97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71348592eaef8b5923aa9d4653a11d70876b41cb41537bf2f4b8dd1ed054eb97"
    sha256 cellar: :any_skip_relocation, sonoma:         "8677f10438c4e519ef6cc1a68da92af9b630cacabfdfbb1ee838f3b00f02bb06"
    sha256 cellar: :any_skip_relocation, ventura:        "8677f10438c4e519ef6cc1a68da92af9b630cacabfdfbb1ee838f3b00f02bb06"
    sha256 cellar: :any_skip_relocation, monterey:       "8677f10438c4e519ef6cc1a68da92af9b630cacabfdfbb1ee838f3b00f02bb06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d007ab38c9f198dd3b2d5ac173de9822cf738dc25611421372546a3fe473d747"
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