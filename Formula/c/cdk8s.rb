class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.271.tgz"
  sha256 "13d0969d0d377de98a4154257bac4ed6c7c0a5d9a0728299a4d9cc822373a719"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95dff11e35a1bde514045cc3a4b95a1d675f086ce9e5addb3cc210a55d2f6f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95dff11e35a1bde514045cc3a4b95a1d675f086ce9e5addb3cc210a55d2f6f1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95dff11e35a1bde514045cc3a4b95a1d675f086ce9e5addb3cc210a55d2f6f1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1283cc938f9d53da356567f019dae74b558181ebc6f4239b595d65f108d49d8e"
    sha256 cellar: :any_skip_relocation, ventura:       "1283cc938f9d53da356567f019dae74b558181ebc6f4239b595d65f108d49d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95dff11e35a1bde514045cc3a4b95a1d675f086ce9e5addb3cc210a55d2f6f1a"
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