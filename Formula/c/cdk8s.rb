class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.120.tgz"
  sha256 "bce7756be009e306696cf67dd4aa2e369e1d1367ad84e6b35ea4427e01b0d646"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d26693a3a8857a2908695d013e786506fe4ffbff9c154077443458339cd67d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3d26693a3a8857a2908695d013e786506fe4ffbff9c154077443458339cd67d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d26693a3a8857a2908695d013e786506fe4ffbff9c154077443458339cd67d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "414816d2afa85e87c4fd4a8fb3b44b061c7ba4cd83d0765c94dc36167b3ded4a"
    sha256 cellar: :any_skip_relocation, ventura:       "414816d2afa85e87c4fd4a8fb3b44b061c7ba4cd83d0765c94dc36167b3ded4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d26693a3a8857a2908695d013e786506fe4ffbff9c154077443458339cd67d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d26693a3a8857a2908695d013e786506fe4ffbff9c154077443458339cd67d8"
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