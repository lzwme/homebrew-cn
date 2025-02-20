class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.329.tgz"
  sha256 "95d9321980d48b25c7b999cc038be4f4b9a485bb76fb5462a2e84b1b91751dce"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c452273867e424d832a6874d91ca4b815158e2a4ae0f6a7340e69ebc8f17f6a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c452273867e424d832a6874d91ca4b815158e2a4ae0f6a7340e69ebc8f17f6a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c452273867e424d832a6874d91ca4b815158e2a4ae0f6a7340e69ebc8f17f6a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "0cc4a88de8ff9314a8cf9f021445e5ab2a0ca18469092d59bfddc33a018e1388"
    sha256 cellar: :any_skip_relocation, ventura:       "0cc4a88de8ff9314a8cf9f021445e5ab2a0ca18469092d59bfddc33a018e1388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c452273867e424d832a6874d91ca4b815158e2a4ae0f6a7340e69ebc8f17f6a0"
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