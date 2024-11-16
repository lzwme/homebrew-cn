class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.264.tgz"
  sha256 "c78488814f0c9078c4cb03ad69af61bc0c6a3cd289725719e9d8c27546c82f79"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc30e4ef41780945ba82dc49783d7c0a404647bc75ca69051c4a4e587fbb314"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc30e4ef41780945ba82dc49783d7c0a404647bc75ca69051c4a4e587fbb314"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bc30e4ef41780945ba82dc49783d7c0a404647bc75ca69051c4a4e587fbb314"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e01f510d137013be0d12ef47228faefc76d7d3c2d44d4cc08750e733718d4ba"
    sha256 cellar: :any_skip_relocation, ventura:       "1e01f510d137013be0d12ef47228faefc76d7d3c2d44d4cc08750e733718d4ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc30e4ef41780945ba82dc49783d7c0a404647bc75ca69051c4a4e587fbb314"
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