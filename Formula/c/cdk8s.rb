class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.257.tgz"
  sha256 "505d7a9aef35a70632ff747aec8b58df04e1d098fe4138868e0a6002078d1bc7"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83e68b6da1ccac36a9a158a917ece3b096de8bfd16a304d54749ac7d4d2d5e48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83e68b6da1ccac36a9a158a917ece3b096de8bfd16a304d54749ac7d4d2d5e48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83e68b6da1ccac36a9a158a917ece3b096de8bfd16a304d54749ac7d4d2d5e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9713158e2ed5db16ecf4ea17baca0902dbc6f9dbe9bffce86dd594df61845a8"
    sha256 cellar: :any_skip_relocation, ventura:       "f9713158e2ed5db16ecf4ea17baca0902dbc6f9dbe9bffce86dd594df61845a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83e68b6da1ccac36a9a158a917ece3b096de8bfd16a304d54749ac7d4d2d5e48"
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