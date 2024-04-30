require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.108.tgz"
  sha256 "c04f012c323cb2ccb5f942dfc30130381e502f25ce98359ffc8a2ed517171527"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81dd7ad02945ee202128780cb4cac13ffe76ea9cb1c0d9f6bf7db53fc50ad5d5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81dd7ad02945ee202128780cb4cac13ffe76ea9cb1c0d9f6bf7db53fc50ad5d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81dd7ad02945ee202128780cb4cac13ffe76ea9cb1c0d9f6bf7db53fc50ad5d5"
    sha256 cellar: :any_skip_relocation, sonoma:         "9dd3a9440b7ab824eb01bb29065f22c98c91c88f1b50a7ffe9b421c10019097d"
    sha256 cellar: :any_skip_relocation, ventura:        "9dd3a9440b7ab824eb01bb29065f22c98c91c88f1b50a7ffe9b421c10019097d"
    sha256 cellar: :any_skip_relocation, monterey:       "9dd3a9440b7ab824eb01bb29065f22c98c91c88f1b50a7ffe9b421c10019097d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81dd7ad02945ee202128780cb4cac13ffe76ea9cb1c0d9f6bf7db53fc50ad5d5"
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