class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.238.tgz"
  sha256 "ba2deae1371aa0b9034c9cd32c83ac590dd5b5292c5a6051a9d744797436c28c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35261b941f84237e81ba09dc73bc9609d5c75b45bd39ef3cac9f341771cbbef4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35261b941f84237e81ba09dc73bc9609d5c75b45bd39ef3cac9f341771cbbef4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "35261b941f84237e81ba09dc73bc9609d5c75b45bd39ef3cac9f341771cbbef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b32d961be9c5eed1532126a188c6560dc863b956991d5b1a345b20b674f70cb"
    sha256 cellar: :any_skip_relocation, ventura:       "5b32d961be9c5eed1532126a188c6560dc863b956991d5b1a345b20b674f70cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35261b941f84237e81ba09dc73bc9609d5c75b45bd39ef3cac9f341771cbbef4"
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