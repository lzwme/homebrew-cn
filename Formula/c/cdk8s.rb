class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.18.tgz"
  sha256 "21b03485fcbee208d2b7cfe6fbc83c19dd037ca02479a2681a6b9c28630ded29"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f5476ace901950d43741a2f92f6bd5eaa651070b99dca4c6a3fbb9e75699891"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f5476ace901950d43741a2f92f6bd5eaa651070b99dca4c6a3fbb9e75699891"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7f5476ace901950d43741a2f92f6bd5eaa651070b99dca4c6a3fbb9e75699891"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4962cca62b95c4a0581a3e70c06bd2d9fe66926224e0a4c4585d1ee8b49370d"
    sha256 cellar: :any_skip_relocation, ventura:       "b4962cca62b95c4a0581a3e70c06bd2d9fe66926224e0a4c4585d1ee8b49370d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f5476ace901950d43741a2f92f6bd5eaa651070b99dca4c6a3fbb9e75699891"
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