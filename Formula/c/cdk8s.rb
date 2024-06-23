require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.153.tgz"
  sha256 "17d2d6bde49c171028562dc4bebae2666742e9304959437e6edc8c40f32aa009"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57ef2d45072e0ba7771bf6d93f97fa4b916441e255c5c59e5ec71d8dd6e33f2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57ef2d45072e0ba7771bf6d93f97fa4b916441e255c5c59e5ec71d8dd6e33f2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57ef2d45072e0ba7771bf6d93f97fa4b916441e255c5c59e5ec71d8dd6e33f2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfeff3cc7522f389d7902df12213f2b0ed15e7019c7b71459420dab237e3a2e2"
    sha256 cellar: :any_skip_relocation, ventura:        "dfeff3cc7522f389d7902df12213f2b0ed15e7019c7b71459420dab237e3a2e2"
    sha256 cellar: :any_skip_relocation, monterey:       "dfeff3cc7522f389d7902df12213f2b0ed15e7019c7b71459420dab237e3a2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a523e6b08a70928504e499f4cc610c6ef520912ea97d9be970a0fcd11cfc41d6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end