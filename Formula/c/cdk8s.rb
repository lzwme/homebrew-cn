class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.52.tgz"
  sha256 "096a3840118bad68cc013b2767ba013b2c4bf42fcbeb087d26f560253ce4d997"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73e71d20a20277d63f1ad8dba9b7f8c556d26053005f2ef420a04953b8f68cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73e71d20a20277d63f1ad8dba9b7f8c556d26053005f2ef420a04953b8f68cd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73e71d20a20277d63f1ad8dba9b7f8c556d26053005f2ef420a04953b8f68cd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "775f39ee9f36b667dfbb840620b6e76ed41b0c209aaa3dff53ed97b4155bc100"
    sha256 cellar: :any_skip_relocation, ventura:       "775f39ee9f36b667dfbb840620b6e76ed41b0c209aaa3dff53ed97b4155bc100"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73e71d20a20277d63f1ad8dba9b7f8c556d26053005f2ef420a04953b8f68cd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73e71d20a20277d63f1ad8dba9b7f8c556d26053005f2ef420a04953b8f68cd3"
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