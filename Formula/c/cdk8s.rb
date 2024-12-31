class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.292.tgz"
  sha256 "aa0ba7ca870fb749e98bfb339b025072a8a4f2c0e2a042d4084ef15bf340ddd1"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee026d66ecb7563110e7ee1d46a854b8358ef10c126fbed806f608a4d4d8f0a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee026d66ecb7563110e7ee1d46a854b8358ef10c126fbed806f608a4d4d8f0a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ee026d66ecb7563110e7ee1d46a854b8358ef10c126fbed806f608a4d4d8f0a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e53e437547b648b2e7e5f2a6450a0907f0e521e40e87c21c2c61a719f648f4c3"
    sha256 cellar: :any_skip_relocation, ventura:       "e53e437547b648b2e7e5f2a6450a0907f0e521e40e87c21c2c61a719f648f4c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee026d66ecb7563110e7ee1d46a854b8358ef10c126fbed806f608a4d4d8f0a1"
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