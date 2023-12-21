require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.15.tgz"
  sha256 "bb77519e75ff7f76944d6a6fc57f1eebb0c2b364d4fcbc7d104df7f1b48bdb14"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "43b372340586886bca5f4526bfe4e80b1705012a53c2ee7f65a8a5f90cc656d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43b372340586886bca5f4526bfe4e80b1705012a53c2ee7f65a8a5f90cc656d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43b372340586886bca5f4526bfe4e80b1705012a53c2ee7f65a8a5f90cc656d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd4663a3be08b118eaaeeef3f43211bc56e30906cbecc8ff1165262cdf6e053d"
    sha256 cellar: :any_skip_relocation, ventura:        "dd4663a3be08b118eaaeeef3f43211bc56e30906cbecc8ff1165262cdf6e053d"
    sha256 cellar: :any_skip_relocation, monterey:       "dd4663a3be08b118eaaeeef3f43211bc56e30906cbecc8ff1165262cdf6e053d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b372340586886bca5f4526bfe4e80b1705012a53c2ee7f65a8a5f90cc656d9"
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