require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.184.0.tgz"
  sha256 "c1f1c53d423ada6d7314e5ef4e187a8f61e84345e4de46d73bb2be947e088a24"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33377741161a22a14eb954c7160e456b21b0ce6a45a0e8cb07bb20a2e54fe284"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33377741161a22a14eb954c7160e456b21b0ce6a45a0e8cb07bb20a2e54fe284"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33377741161a22a14eb954c7160e456b21b0ce6a45a0e8cb07bb20a2e54fe284"
    sha256 cellar: :any_skip_relocation, sonoma:         "e14fffa34331f741b019170da773efdeea3f83d42a9765cdaabb8dcd70a40c92"
    sha256 cellar: :any_skip_relocation, ventura:        "e14fffa34331f741b019170da773efdeea3f83d42a9765cdaabb8dcd70a40c92"
    sha256 cellar: :any_skip_relocation, monterey:       "e14fffa34331f741b019170da773efdeea3f83d42a9765cdaabb8dcd70a40c92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33377741161a22a14eb954c7160e456b21b0ce6a45a0e8cb07bb20a2e54fe284"
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