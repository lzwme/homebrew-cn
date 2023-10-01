require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.113.0.tgz"
  sha256 "c6862802ce1508948969ae0708c0b1757c2db0e9dbad56210c4bdfa6da75e33d"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f816607e5c1d0c199ec8eba0c48858cfc247fab89242ae3f5c86efaf32efcdb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f816607e5c1d0c199ec8eba0c48858cfc247fab89242ae3f5c86efaf32efcdb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f816607e5c1d0c199ec8eba0c48858cfc247fab89242ae3f5c86efaf32efcdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "bc9333ba5a13fd1156dbbb38f48d36b2420563c1df51726fd6ecfe2ab1519cc7"
    sha256 cellar: :any_skip_relocation, ventura:        "bc9333ba5a13fd1156dbbb38f48d36b2420563c1df51726fd6ecfe2ab1519cc7"
    sha256 cellar: :any_skip_relocation, monterey:       "bc9333ba5a13fd1156dbbb38f48d36b2420563c1df51726fd6ecfe2ab1519cc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f816607e5c1d0c199ec8eba0c48858cfc247fab89242ae3f5c86efaf32efcdb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end