require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.62.0.tgz"
  sha256 "7b6c222ae39776f9886bd6974cdbc13ec2e977662aaa370acaee1d39176a398b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3524df2b0dd21d25f76ca6b450fce2275283b051e685e91630e7fbe5cd8b41a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3524df2b0dd21d25f76ca6b450fce2275283b051e685e91630e7fbe5cd8b41a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3524df2b0dd21d25f76ca6b450fce2275283b051e685e91630e7fbe5cd8b41a8"
    sha256 cellar: :any_skip_relocation, ventura:        "ae038830d5c02e142d5962932af386de82db04f6156de6cb94b09c2bbbabe8a5"
    sha256 cellar: :any_skip_relocation, monterey:       "ae038830d5c02e142d5962932af386de82db04f6156de6cb94b09c2bbbabe8a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae038830d5c02e142d5962932af386de82db04f6156de6cb94b09c2bbbabe8a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3524df2b0dd21d25f76ca6b450fce2275283b051e685e91630e7fbe5cd8b41a8"
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