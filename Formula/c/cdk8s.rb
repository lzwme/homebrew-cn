class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.51.tgz"
  sha256 "8d857dd94236b3f9581ec40fe287269a5713b1fe7d091be41a2b7a468927213b"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2da73d5227ff24960c3fe5aae95ff35bc77e2a65533db95da3f381945784fdaa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2da73d5227ff24960c3fe5aae95ff35bc77e2a65533db95da3f381945784fdaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2da73d5227ff24960c3fe5aae95ff35bc77e2a65533db95da3f381945784fdaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c70a4308cab35a335a15c1204b395c13df935d88edeb9a7a1ea383d749cd85f"
    sha256 cellar: :any_skip_relocation, ventura:       "2c70a4308cab35a335a15c1204b395c13df935d88edeb9a7a1ea383d749cd85f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2da73d5227ff24960c3fe5aae95ff35bc77e2a65533db95da3f381945784fdaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2da73d5227ff24960c3fe5aae95ff35bc77e2a65533db95da3f381945784fdaa"
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