class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.5.tgz"
  sha256 "065e1f94eb778891bf538f877344400a9d75b214f3214753cb4ab3df968ac6f5"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48b97fe691f16ddd6f34f2dd69dd8a9e6d872851bf63050e8fb6126aca2def73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48b97fe691f16ddd6f34f2dd69dd8a9e6d872851bf63050e8fb6126aca2def73"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "48b97fe691f16ddd6f34f2dd69dd8a9e6d872851bf63050e8fb6126aca2def73"
    sha256 cellar: :any_skip_relocation, sonoma:        "fae462598948ebb33606ddcf323ee8977fd649be920bb548100a138602e3d299"
    sha256 cellar: :any_skip_relocation, ventura:       "fae462598948ebb33606ddcf323ee8977fd649be920bb548100a138602e3d299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48b97fe691f16ddd6f34f2dd69dd8a9e6d872851bf63050e8fb6126aca2def73"
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