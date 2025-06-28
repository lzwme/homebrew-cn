class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.113.tgz"
  sha256 "3843bfbb98a31ea53cb62c0eb2bff40279868a81004c4f7bc3b2af51c5d0c879"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aeb2ec3b0e6401a8ed99ae5c019ee7a2286d6d57fa7a0596de705e14d575d171"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aeb2ec3b0e6401a8ed99ae5c019ee7a2286d6d57fa7a0596de705e14d575d171"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aeb2ec3b0e6401a8ed99ae5c019ee7a2286d6d57fa7a0596de705e14d575d171"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f30d91133a659423540a3daa2b69470668932d569313f1aa6a04a8376aee739"
    sha256 cellar: :any_skip_relocation, ventura:       "8f30d91133a659423540a3daa2b69470668932d569313f1aa6a04a8376aee739"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aeb2ec3b0e6401a8ed99ae5c019ee7a2286d6d57fa7a0596de705e14d575d171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aeb2ec3b0e6401a8ed99ae5c019ee7a2286d6d57fa7a0596de705e14d575d171"
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