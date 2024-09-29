class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.230.tgz"
  sha256 "7ec9cdc024363ab86d23b24a3180894cbb1adda6008040b6d5edca9b3a16f2ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a6a741434abd75af2124cf6578012dc599466627918b65ff61de05f3f8d6965"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a6a741434abd75af2124cf6578012dc599466627918b65ff61de05f3f8d6965"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8a6a741434abd75af2124cf6578012dc599466627918b65ff61de05f3f8d6965"
    sha256 cellar: :any_skip_relocation, sonoma:        "84e56c339bce3a1abcb86c4cf38923ce42910d7f44abf180b07d075b85601e30"
    sha256 cellar: :any_skip_relocation, ventura:       "84e56c339bce3a1abcb86c4cf38923ce42910d7f44abf180b07d075b85601e30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a6a741434abd75af2124cf6578012dc599466627918b65ff61de05f3f8d6965"
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