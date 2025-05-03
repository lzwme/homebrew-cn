class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.58.tgz"
  sha256 "b1187520493730966e2c09ed80fe3b2c97b9a1d41d0f8f6b2add6242a7118137"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74a4e63475358ab6dd5200dea7d220a62917535fde83a41b9e098de33edc0e49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74a4e63475358ab6dd5200dea7d220a62917535fde83a41b9e098de33edc0e49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74a4e63475358ab6dd5200dea7d220a62917535fde83a41b9e098de33edc0e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "0091e193250a01ed4df6b21944b9cec2adda63a942ad6a88a992d6fe573c2d35"
    sha256 cellar: :any_skip_relocation, ventura:       "0091e193250a01ed4df6b21944b9cec2adda63a942ad6a88a992d6fe573c2d35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74a4e63475358ab6dd5200dea7d220a62917535fde83a41b9e098de33edc0e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a4e63475358ab6dd5200dea7d220a62917535fde83a41b9e098de33edc0e49"
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