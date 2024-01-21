require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.32.tgz"
  sha256 "167b6133829f8fd0eca43b199669f38cab5d0c782220e21fea56e639f1bbd6e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a119518b3d50150bd55298760545941e72422f3f4b8e161d5880326c3a522b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a119518b3d50150bd55298760545941e72422f3f4b8e161d5880326c3a522b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a119518b3d50150bd55298760545941e72422f3f4b8e161d5880326c3a522b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e3b8b92ff385296cee2f87b4b8b694b821ab3e7d4bb13d2a354ae42a4811e7d"
    sha256 cellar: :any_skip_relocation, ventura:        "4e3b8b92ff385296cee2f87b4b8b694b821ab3e7d4bb13d2a354ae42a4811e7d"
    sha256 cellar: :any_skip_relocation, monterey:       "4e3b8b92ff385296cee2f87b4b8b694b821ab3e7d4bb13d2a354ae42a4811e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a119518b3d50150bd55298760545941e72422f3f4b8e161d5880326c3a522b8"
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