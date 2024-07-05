require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.164.tgz"
  sha256 "7bdc08e13b54361969ce948f8e3e953797b71aeecdca3141aa6b255f18bed14d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bad624ceabc73f60f127c565d1887979c3d75e7aede59fc3ea0d8031d0b40c16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bad624ceabc73f60f127c565d1887979c3d75e7aede59fc3ea0d8031d0b40c16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bad624ceabc73f60f127c565d1887979c3d75e7aede59fc3ea0d8031d0b40c16"
    sha256 cellar: :any_skip_relocation, sonoma:         "0eb7ec5d591b6db217d37eeaa787c16f0e1640218a4d1e5ff8c8ca2b1985266c"
    sha256 cellar: :any_skip_relocation, ventura:        "0eb7ec5d591b6db217d37eeaa787c16f0e1640218a4d1e5ff8c8ca2b1985266c"
    sha256 cellar: :any_skip_relocation, monterey:       "0eb7ec5d591b6db217d37eeaa787c16f0e1640218a4d1e5ff8c8ca2b1985266c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22497691d4c2df46973d8816e9666a0e6d772a93768fffb0e55031bce301bab"
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