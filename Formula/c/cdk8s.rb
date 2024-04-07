require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.93.tgz"
  sha256 "c1186eeab15df5dc89e381cb4a73f59676a4da97f1e8be2255fa8b574b5ddd19"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f82af9a45db8caeeb55abe3a255e339c7eba702df09ae3afff74d75c5340164"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f82af9a45db8caeeb55abe3a255e339c7eba702df09ae3afff74d75c5340164"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f82af9a45db8caeeb55abe3a255e339c7eba702df09ae3afff74d75c5340164"
    sha256 cellar: :any_skip_relocation, sonoma:         "08d94f5fc15e8b63c490f1d0da68de40eb52adaa56b7debaadde5a2be56691a2"
    sha256 cellar: :any_skip_relocation, ventura:        "08d94f5fc15e8b63c490f1d0da68de40eb52adaa56b7debaadde5a2be56691a2"
    sha256 cellar: :any_skip_relocation, monterey:       "08d94f5fc15e8b63c490f1d0da68de40eb52adaa56b7debaadde5a2be56691a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f82af9a45db8caeeb55abe3a255e339c7eba702df09ae3afff74d75c5340164"
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