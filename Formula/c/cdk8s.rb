require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.9.tgz"
  sha256 "4c285a7ec76eeb4f5b2717489d258cbb69bc06622d9e4fefdc8d50846ad58cd8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5974140fef953adee977a9fd5f858ca7fded4fbe9c2555daf35bd3f8a3ed0cc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5974140fef953adee977a9fd5f858ca7fded4fbe9c2555daf35bd3f8a3ed0cc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5974140fef953adee977a9fd5f858ca7fded4fbe9c2555daf35bd3f8a3ed0cc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb2329f2cca5e5b6be43b3c57ab9fb3145f50971c983d8d98bd133ca0064e73d"
    sha256 cellar: :any_skip_relocation, ventura:        "fb2329f2cca5e5b6be43b3c57ab9fb3145f50971c983d8d98bd133ca0064e73d"
    sha256 cellar: :any_skip_relocation, monterey:       "fb2329f2cca5e5b6be43b3c57ab9fb3145f50971c983d8d98bd133ca0064e73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5974140fef953adee977a9fd5f858ca7fded4fbe9c2555daf35bd3f8a3ed0cc0"
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