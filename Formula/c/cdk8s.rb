require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.172.0.tgz"
  sha256 "d156ac8ad24ff440e185ada1d35bd53454a6921320c240e101d511d46de49069"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af023606cb78730e7831661f0ac9bd734e02d2b20af67b2178aebb6f4593f840"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af023606cb78730e7831661f0ac9bd734e02d2b20af67b2178aebb6f4593f840"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af023606cb78730e7831661f0ac9bd734e02d2b20af67b2178aebb6f4593f840"
    sha256 cellar: :any_skip_relocation, sonoma:         "b9409a2e3efaad391019bc81756fbe8146dadec5bdf714eba92dde6e4208595e"
    sha256 cellar: :any_skip_relocation, ventura:        "b9409a2e3efaad391019bc81756fbe8146dadec5bdf714eba92dde6e4208595e"
    sha256 cellar: :any_skip_relocation, monterey:       "b9409a2e3efaad391019bc81756fbe8146dadec5bdf714eba92dde6e4208595e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af023606cb78730e7831661f0ac9bd734e02d2b20af67b2178aebb6f4593f840"
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