class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.305.tgz"
  sha256 "d7e55302173f0a155b51955a43a3ce78189093aff4245aad43e2e8a8a8f2d15e"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "679e62db7bc6cce235b9d1c3dee309696c7e02f6a61b1cfb2e3db29f45c94978"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "679e62db7bc6cce235b9d1c3dee309696c7e02f6a61b1cfb2e3db29f45c94978"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "679e62db7bc6cce235b9d1c3dee309696c7e02f6a61b1cfb2e3db29f45c94978"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c8d2c24b7b79f1ff8084e310d3ceb7e9feb59596e020c31f8142f6b19645c3e"
    sha256 cellar: :any_skip_relocation, ventura:       "8c8d2c24b7b79f1ff8084e310d3ceb7e9feb59596e020c31f8142f6b19645c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "679e62db7bc6cce235b9d1c3dee309696c7e02f6a61b1cfb2e3db29f45c94978"
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