require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.175.0.tgz"
  sha256 "0deb932b7fef93a63f3dddce63bbb2a61f04bded8d0ae685a3a299284e30b9d5"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de341475f2ff249d87b5b6cc571bfc169f55ce3ce87b7d3e91b954e4e26a2187"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "de341475f2ff249d87b5b6cc571bfc169f55ce3ce87b7d3e91b954e4e26a2187"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de341475f2ff249d87b5b6cc571bfc169f55ce3ce87b7d3e91b954e4e26a2187"
    sha256 cellar: :any_skip_relocation, sonoma:         "c1daac3886ea59bb035802e73b76336163ef7207cf11a8e748e6e86ac44ba503"
    sha256 cellar: :any_skip_relocation, ventura:        "c1daac3886ea59bb035802e73b76336163ef7207cf11a8e748e6e86ac44ba503"
    sha256 cellar: :any_skip_relocation, monterey:       "c1daac3886ea59bb035802e73b76336163ef7207cf11a8e748e6e86ac44ba503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de341475f2ff249d87b5b6cc571bfc169f55ce3ce87b7d3e91b954e4e26a2187"
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