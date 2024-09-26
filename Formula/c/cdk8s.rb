class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.227.tgz"
  sha256 "756bc222e7ab850577e4cde5fcaeaf374b35e14b1f18b654a25987fac6c343d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46af67b7ae830a8f8429dce0d26a775c12501906b124ca3b05c906c13472be1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46af67b7ae830a8f8429dce0d26a775c12501906b124ca3b05c906c13472be1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46af67b7ae830a8f8429dce0d26a775c12501906b124ca3b05c906c13472be1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e4bee4808a607acda3e42fa6e365da623870427b960585f37bfeee1b58e59f8"
    sha256 cellar: :any_skip_relocation, ventura:       "0e4bee4808a607acda3e42fa6e365da623870427b960585f37bfeee1b58e59f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46af67b7ae830a8f8429dce0d26a775c12501906b124ca3b05c906c13472be1e"
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