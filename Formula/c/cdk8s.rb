class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.61.tgz"
  sha256 "b44fde9934140e190fb202e5f590e16f30a646e38710163c2b5c94ccc3a0035b"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99eb1f52130415cc7742aa23d1fe4a2aa7eb781db00439a59ae031344eede127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99eb1f52130415cc7742aa23d1fe4a2aa7eb781db00439a59ae031344eede127"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99eb1f52130415cc7742aa23d1fe4a2aa7eb781db00439a59ae031344eede127"
    sha256 cellar: :any_skip_relocation, sonoma:        "010a0d3ba5181555e2efa3e04af2d18b32c14ada2bf22667b76d4685e6c6fc11"
    sha256 cellar: :any_skip_relocation, ventura:       "010a0d3ba5181555e2efa3e04af2d18b32c14ada2bf22667b76d4685e6c6fc11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99eb1f52130415cc7742aa23d1fe4a2aa7eb781db00439a59ae031344eede127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99eb1f52130415cc7742aa23d1fe4a2aa7eb781db00439a59ae031344eede127"
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