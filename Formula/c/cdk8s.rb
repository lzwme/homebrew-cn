class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.21.tgz"
  sha256 "197a56fcca05bb17879786690517ec122c3008048860482d70603750208bb89b"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d81249d06a9fae3864879d49651808e596588cadea11ed6d6cb62010bdab38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13d81249d06a9fae3864879d49651808e596588cadea11ed6d6cb62010bdab38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13d81249d06a9fae3864879d49651808e596588cadea11ed6d6cb62010bdab38"
    sha256 cellar: :any_skip_relocation, sonoma:        "0bc6e0eb9c6b1fd625ca18e872de67c331acb98314826526ef5ec47fdc00937a"
    sha256 cellar: :any_skip_relocation, ventura:       "0bc6e0eb9c6b1fd625ca18e872de67c331acb98314826526ef5ec47fdc00937a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d81249d06a9fae3864879d49651808e596588cadea11ed6d6cb62010bdab38"
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