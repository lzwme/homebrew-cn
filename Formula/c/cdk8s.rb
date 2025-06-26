class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.111.tgz"
  sha256 "f15d94a9a72bc45fa18fe1e1e9b50adbd38cef9e166c503c76e26b887dfeb363"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3225bdd474ac5f87a54ee4a19faf69e35c513519b0e1aace4fa114e1c2c50a49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3225bdd474ac5f87a54ee4a19faf69e35c513519b0e1aace4fa114e1c2c50a49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3225bdd474ac5f87a54ee4a19faf69e35c513519b0e1aace4fa114e1c2c50a49"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf9e59c14f77abf8f82e7042e61715e81651b407ae603a91f94c8c94aad6eb09"
    sha256 cellar: :any_skip_relocation, ventura:       "cf9e59c14f77abf8f82e7042e61715e81651b407ae603a91f94c8c94aad6eb09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3225bdd474ac5f87a54ee4a19faf69e35c513519b0e1aace4fa114e1c2c50a49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3225bdd474ac5f87a54ee4a19faf69e35c513519b0e1aace4fa114e1c2c50a49"
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