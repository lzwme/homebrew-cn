require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.44.tgz"
  sha256 "12005ab486cfb9e7ba1dfd4fb196dd1e581597487db6c91a147385d15f3556ff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b36af7458597bd451197b562f08383ccae0d286fe41556efdd420cbcc5bf279d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b36af7458597bd451197b562f08383ccae0d286fe41556efdd420cbcc5bf279d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b36af7458597bd451197b562f08383ccae0d286fe41556efdd420cbcc5bf279d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5a830e04e98bb9ca27d42ddf90d13e396982b9455a2a9a9cb097f5337b9cb48"
    sha256 cellar: :any_skip_relocation, ventura:        "a5a830e04e98bb9ca27d42ddf90d13e396982b9455a2a9a9cb097f5337b9cb48"
    sha256 cellar: :any_skip_relocation, monterey:       "a5a830e04e98bb9ca27d42ddf90d13e396982b9455a2a9a9cb097f5337b9cb48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b36af7458597bd451197b562f08383ccae0d286fe41556efdd420cbcc5bf279d"
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