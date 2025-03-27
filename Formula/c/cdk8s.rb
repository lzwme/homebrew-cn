class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.29.tgz"
  sha256 "5d13bf5c8741fb5a2977caa61015544e883fa7b3091689107ffd37c947b6ee79"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dca42207bc7bc1314a2cb44c20037076bc2fa684e2bc1b3be0ae305ef0698b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dca42207bc7bc1314a2cb44c20037076bc2fa684e2bc1b3be0ae305ef0698b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dca42207bc7bc1314a2cb44c20037076bc2fa684e2bc1b3be0ae305ef0698b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f183eea577c80ff9bdae59ded3211685ab74a7f19f6106c8877ff48559ad1a7c"
    sha256 cellar: :any_skip_relocation, ventura:       "f183eea577c80ff9bdae59ded3211685ab74a7f19f6106c8877ff48559ad1a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dca42207bc7bc1314a2cb44c20037076bc2fa684e2bc1b3be0ae305ef0698b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dca42207bc7bc1314a2cb44c20037076bc2fa684e2bc1b3be0ae305ef0698b9"
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