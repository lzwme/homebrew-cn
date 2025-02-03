class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.198.312.tgz"
  sha256 "3e67eb45ea1a56fd0f4b2ba9c0af9a962ed44f01ff1cbdd4c45f874db3a56325"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c156362f4a98e55352a7d1a33468eb3f14a6f38b726aacbfc027bbdb6b00c04d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c156362f4a98e55352a7d1a33468eb3f14a6f38b726aacbfc027bbdb6b00c04d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c156362f4a98e55352a7d1a33468eb3f14a6f38b726aacbfc027bbdb6b00c04d"
    sha256 cellar: :any_skip_relocation, sonoma:        "142d7b8f673723b437103a027825409b0815d6c94c57c6e4cc147d9eadc06406"
    sha256 cellar: :any_skip_relocation, ventura:       "142d7b8f673723b437103a027825409b0815d6c94c57c6e4cc147d9eadc06406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c156362f4a98e55352a7d1a33468eb3f14a6f38b726aacbfc027bbdb6b00c04d"
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