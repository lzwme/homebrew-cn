class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.266.tgz"
  sha256 "e1596821c5d21d071784097cb7ea7dfb82b28dfc7b0b99230f5636f9eba237d0"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "26aaf883ff4340520980cf2e2a39fcdd02a602ac143523596d5ee07e282e9de1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "26aaf883ff4340520980cf2e2a39fcdd02a602ac143523596d5ee07e282e9de1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26aaf883ff4340520980cf2e2a39fcdd02a602ac143523596d5ee07e282e9de1"
    sha256 cellar: :any_skip_relocation, sonoma:        "7dc42233574bddf282060a6212c047650211f1b8b040cc898a688088da424c95"
    sha256 cellar: :any_skip_relocation, ventura:       "7dc42233574bddf282060a6212c047650211f1b8b040cc898a688088da424c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26aaf883ff4340520980cf2e2a39fcdd02a602ac143523596d5ee07e282e9de1"
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