class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.220.tgz"
  sha256 "b5a656c14b34d42c08db75530d5cd727ae3052c5dc775ca8d0432e6df81179e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5080a4addb560963b80a83c8007c8114dd9bb5adfbff31e9de836c7643beb69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5080a4addb560963b80a83c8007c8114dd9bb5adfbff31e9de836c7643beb69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5080a4addb560963b80a83c8007c8114dd9bb5adfbff31e9de836c7643beb69"
    sha256 cellar: :any_skip_relocation, sonoma:        "59a6a231f45be689162677cd75bee4766b416bb9c77a7d1548d811bfe3fa4ff5"
    sha256 cellar: :any_skip_relocation, ventura:       "59a6a231f45be689162677cd75bee4766b416bb9c77a7d1548d811bfe3fa4ff5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5080a4addb560963b80a83c8007c8114dd9bb5adfbff31e9de836c7643beb69"
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