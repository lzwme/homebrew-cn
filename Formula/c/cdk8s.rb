class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.20.tgz"
  sha256 "5713995d8e0113e9a5c2e0b75a1aa6846adea46a518a8543923577ef8ce07c1d"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b29d1acfe7ac446dc8bcc82ba82a1d9c16b253e546c0fb26af4e4bbcf97ccff6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b29d1acfe7ac446dc8bcc82ba82a1d9c16b253e546c0fb26af4e4bbcf97ccff6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b29d1acfe7ac446dc8bcc82ba82a1d9c16b253e546c0fb26af4e4bbcf97ccff6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d79acc1d2c4b02064a138814a281a4a6d4c823f108ed8ddffb944a83771f6d92"
    sha256 cellar: :any_skip_relocation, ventura:       "d79acc1d2c4b02064a138814a281a4a6d4c823f108ed8ddffb944a83771f6d92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b29d1acfe7ac446dc8bcc82ba82a1d9c16b253e546c0fb26af4e4bbcf97ccff6"
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