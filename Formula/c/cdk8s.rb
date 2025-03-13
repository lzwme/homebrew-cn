class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.15.tgz"
  sha256 "199ebbc8b542b5cc059977d674d1ed55286cda56c9dfc0c6ddce2d10a1e66f1f"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f2fac864050b3fc282983564fdc83624f66cf8e71d871ae7154672fe691b29d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f2fac864050b3fc282983564fdc83624f66cf8e71d871ae7154672fe691b29d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f2fac864050b3fc282983564fdc83624f66cf8e71d871ae7154672fe691b29d"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0a2c14a767a4e20b94a9c367491432c4fe712366b4185fd6e9ee96e6279be54"
    sha256 cellar: :any_skip_relocation, ventura:       "a0a2c14a767a4e20b94a9c367491432c4fe712366b4185fd6e9ee96e6279be54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f2fac864050b3fc282983564fdc83624f66cf8e71d871ae7154672fe691b29d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end