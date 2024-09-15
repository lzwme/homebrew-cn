class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.217.tgz"
  sha256 "7b6e0c57ba85d67180ccd6555cf7eebad0827cfad37ec0046c5703408d01e6bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f70bd071482fe40b4719473e48c27b44e0796a6a0b929d6858980ae12ded8ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f70bd071482fe40b4719473e48c27b44e0796a6a0b929d6858980ae12ded8ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f70bd071482fe40b4719473e48c27b44e0796a6a0b929d6858980ae12ded8ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "a26db560483f5056859a4b9bd9f1c907980f0e45cc52c86375d20ac389186ed7"
    sha256 cellar: :any_skip_relocation, ventura:       "a26db560483f5056859a4b9bd9f1c907980f0e45cc52c86375d20ac389186ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f70bd071482fe40b4719473e48c27b44e0796a6a0b929d6858980ae12ded8ce"
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