class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.200.84.tgz"
  sha256 "f8f5460ae91098d288fc736578c3093cd484c283bfa514b975a5e7192a1aee32"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd8bf854003e6cd84c0a4375a204d4d9313a3b69493ef810e9f251f22bce987b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd8bf854003e6cd84c0a4375a204d4d9313a3b69493ef810e9f251f22bce987b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fd8bf854003e6cd84c0a4375a204d4d9313a3b69493ef810e9f251f22bce987b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4f30ee9bca913862b1fb833f67701dab0bfefb41e9876d51be849d5109be85d"
    sha256 cellar: :any_skip_relocation, ventura:       "a4f30ee9bca913862b1fb833f67701dab0bfefb41e9876d51be849d5109be85d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd8bf854003e6cd84c0a4375a204d4d9313a3b69493ef810e9f251f22bce987b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd8bf854003e6cd84c0a4375a204d4d9313a3b69493ef810e9f251f22bce987b"
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