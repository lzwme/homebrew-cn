require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.169.tgz"
  sha256 "bb53d32f5fa4cd57ea506ede673219cd2c4135cba0ab7c5a7b45bd9a561e93ee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11c5ee1c27333a22f501f0ee711296e85a81dd5a3cbc1044bfe5b36c40140753"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "11c5ee1c27333a22f501f0ee711296e85a81dd5a3cbc1044bfe5b36c40140753"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11c5ee1c27333a22f501f0ee711296e85a81dd5a3cbc1044bfe5b36c40140753"
    sha256 cellar: :any_skip_relocation, sonoma:         "96626ef60aadb26552cd1ef753cc3e8f8b6024d858ea4b18a8e40daebdc84849"
    sha256 cellar: :any_skip_relocation, ventura:        "96626ef60aadb26552cd1ef753cc3e8f8b6024d858ea4b18a8e40daebdc84849"
    sha256 cellar: :any_skip_relocation, monterey:       "96626ef60aadb26552cd1ef753cc3e8f8b6024d858ea4b18a8e40daebdc84849"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d4a9fef640b637e331cdd4fc3d40582d24b6c54d538da59306018c3b06f3cf5"
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