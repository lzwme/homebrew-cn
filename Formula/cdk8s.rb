require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.116.tgz"
  sha256 "6566805d57619129f06c3a5a06f8ccefd7695e1ad9049e8bbe1481a6acdf97a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9911c4f1bb526fd7714c2dfb57c2ec1a809b8dfee720d8670658366d6a69f0ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9911c4f1bb526fd7714c2dfb57c2ec1a809b8dfee720d8670658366d6a69f0ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da5ebe7863ad14f3b7237ca35cec566bbb8c929342c3ba59fb29fb4af5c1714d"
    sha256 cellar: :any_skip_relocation, ventura:        "22a87b90a97fc3506be78112950b3488e8ff83854fdd20d0031f2af0d72a3dc9"
    sha256 cellar: :any_skip_relocation, monterey:       "22a87b90a97fc3506be78112950b3488e8ff83854fdd20d0031f2af0d72a3dc9"
    sha256 cellar: :any_skip_relocation, big_sur:        "22a87b90a97fc3506be78112950b3488e8ff83854fdd20d0031f2af0d72a3dc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27db82811e1ea14bbadd3f43278d55632686021f92b82d290930b9a9efa0954c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end