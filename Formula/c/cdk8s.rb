class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.57.tgz"
  sha256 "b3b9b2d7c2dc8fccfe86a24e475517db84ac84d7f0560929ca0529fece2ce9c8"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80f78ed2abb8f138973323e16b2c8b274e19aa159aee493bf72e825262eb62eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80f78ed2abb8f138973323e16b2c8b274e19aa159aee493bf72e825262eb62eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80f78ed2abb8f138973323e16b2c8b274e19aa159aee493bf72e825262eb62eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a00343652de2b83401ba795d80e5cae69a9c5503891a5af3aff8f02d6cd5c2f0"
    sha256 cellar: :any_skip_relocation, ventura:       "a00343652de2b83401ba795d80e5cae69a9c5503891a5af3aff8f02d6cd5c2f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80f78ed2abb8f138973323e16b2c8b274e19aa159aee493bf72e825262eb62eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80f78ed2abb8f138973323e16b2c8b274e19aa159aee493bf72e825262eb62eb"
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