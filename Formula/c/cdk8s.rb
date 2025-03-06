class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.8.tgz"
  sha256 "2768b6be87dc8f81d957cd6ec4782642c43b4f78c5476e85a9f0c618df18e8b6"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d224de3cf053aa1cfba7445ddf26a462df1b3695bfb1eb37b9c894c2a58d35a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d224de3cf053aa1cfba7445ddf26a462df1b3695bfb1eb37b9c894c2a58d35a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6d224de3cf053aa1cfba7445ddf26a462df1b3695bfb1eb37b9c894c2a58d35a"
    sha256 cellar: :any_skip_relocation, sonoma:        "587c9cd8cb5ac033c2550fb2e700c80f723c5e6f77e7c389d5bc8bfaab0acb69"
    sha256 cellar: :any_skip_relocation, ventura:       "587c9cd8cb5ac033c2550fb2e700c80f723c5e6f77e7c389d5bc8bfaab0acb69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d224de3cf053aa1cfba7445ddf26a462df1b3695bfb1eb37b9c894c2a58d35a"
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