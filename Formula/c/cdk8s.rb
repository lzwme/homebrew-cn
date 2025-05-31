class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.85.tgz"
  sha256 "69c742ea78635e91068518b696c36122ae3847ceaccfb33a61f5ab3dd1c50ae7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c9e8d2dab0c677a9e6f4ec0d8fbb91349641e886bb2d26b52b10cdae0d12eba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c9e8d2dab0c677a9e6f4ec0d8fbb91349641e886bb2d26b52b10cdae0d12eba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c9e8d2dab0c677a9e6f4ec0d8fbb91349641e886bb2d26b52b10cdae0d12eba"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b47b593eb8b4693ea87f0a2ead5c9b9225025a1a71b714541da31b3ab70d345"
    sha256 cellar: :any_skip_relocation, ventura:       "1b47b593eb8b4693ea87f0a2ead5c9b9225025a1a71b714541da31b3ab70d345"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c9e8d2dab0c677a9e6f4ec0d8fbb91349641e886bb2d26b52b10cdae0d12eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c9e8d2dab0c677a9e6f4ec0d8fbb91349641e886bb2d26b52b10cdae0d12eba"
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