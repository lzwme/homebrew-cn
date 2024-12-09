class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.277.tgz"
  sha256 "84dea0dc9c5b70ff29a56980c6404f8d13eae57909133d2f13316b12c0c3e942"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e407402787451e3bdcfdd823699d9ffc5e9d3bf37d511f388b3004f1bef19d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e407402787451e3bdcfdd823699d9ffc5e9d3bf37d511f388b3004f1bef19d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e407402787451e3bdcfdd823699d9ffc5e9d3bf37d511f388b3004f1bef19d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e66ae1529d4a31072e94bc1176fcaddafc655780f185fc79377af1318ea0ed2"
    sha256 cellar: :any_skip_relocation, ventura:       "9e66ae1529d4a31072e94bc1176fcaddafc655780f185fc79377af1318ea0ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e407402787451e3bdcfdd823699d9ffc5e9d3bf37d511f388b3004f1bef19d4"
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