require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.119.0.tgz"
  sha256 "e636109c50cc841291145499f1e077a6b065ac5d9a2cf5c891cf5f226b83701a"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84fe16d2b4ae87161d01cdacc7c0e6d16cf2b10e65f5b894bdd965a7e92c9002"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84fe16d2b4ae87161d01cdacc7c0e6d16cf2b10e65f5b894bdd965a7e92c9002"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84fe16d2b4ae87161d01cdacc7c0e6d16cf2b10e65f5b894bdd965a7e92c9002"
    sha256 cellar: :any_skip_relocation, sonoma:         "cee05d13e750cc463aaffd9178ed0fea392be617003952d77b3e1f84fd5b013f"
    sha256 cellar: :any_skip_relocation, ventura:        "cee05d13e750cc463aaffd9178ed0fea392be617003952d77b3e1f84fd5b013f"
    sha256 cellar: :any_skip_relocation, monterey:       "cee05d13e750cc463aaffd9178ed0fea392be617003952d77b3e1f84fd5b013f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84fe16d2b4ae87161d01cdacc7c0e6d16cf2b10e65f5b894bdd965a7e92c9002"
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