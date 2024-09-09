class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.211.tgz"
  sha256 "4a4bb979f3bee494744cfd1bd7b1e206081019f9e2508116014defc916b506cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8423d941c71dd29c0bd4491107928882c08b4ac3ea5fe8e79d756b3b88a37de2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8423d941c71dd29c0bd4491107928882c08b4ac3ea5fe8e79d756b3b88a37de2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8423d941c71dd29c0bd4491107928882c08b4ac3ea5fe8e79d756b3b88a37de2"
    sha256 cellar: :any_skip_relocation, sonoma:         "07c0db0d0a260224b793c0627b0f7c3ab34c013bf06189ed02b9a7b95fb11081"
    sha256 cellar: :any_skip_relocation, ventura:        "07c0db0d0a260224b793c0627b0f7c3ab34c013bf06189ed02b9a7b95fb11081"
    sha256 cellar: :any_skip_relocation, monterey:       "07c0db0d0a260224b793c0627b0f7c3ab34c013bf06189ed02b9a7b95fb11081"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8423d941c71dd29c0bd4491107928882c08b4ac3ea5fe8e79d756b3b88a37de2"
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