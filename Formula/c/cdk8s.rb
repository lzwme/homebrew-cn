class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.140.tgz"
  sha256 "e8b91546e95213ca8dcc2d929814f0406a20737d5b909517e38e3dc695a70b39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7da0ba108ff33ea5b9ff2ac058e3a25dc0636d0761eae795d4d3f7bfe9553d9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7da0ba108ff33ea5b9ff2ac058e3a25dc0636d0761eae795d4d3f7bfe9553d9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7da0ba108ff33ea5b9ff2ac058e3a25dc0636d0761eae795d4d3f7bfe9553d9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "99923ce3738567b267634c671f1688171d9c423584baeac7df96a8b0e159875a"
    sha256 cellar: :any_skip_relocation, ventura:       "99923ce3738567b267634c671f1688171d9c423584baeac7df96a8b0e159875a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7da0ba108ff33ea5b9ff2ac058e3a25dc0636d0761eae795d4d3f7bfe9553d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7da0ba108ff33ea5b9ff2ac058e3a25dc0636d0761eae795d4d3f7bfe9553d9a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end