require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.27.tgz"
  sha256 "877f06c59354d9f750c459429eb21250fc412c5884dfa2c276ee8842ec643557"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "579955d51c7beef80999fe96871f9ec4d69976915be2d598af45e15213f5a2f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "579955d51c7beef80999fe96871f9ec4d69976915be2d598af45e15213f5a2f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "579955d51c7beef80999fe96871f9ec4d69976915be2d598af45e15213f5a2f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "bee42d89a9d27667096493fb6fc9ccd03705fcb6d8a38de919737dd327f96fea"
    sha256 cellar: :any_skip_relocation, ventura:        "bee42d89a9d27667096493fb6fc9ccd03705fcb6d8a38de919737dd327f96fea"
    sha256 cellar: :any_skip_relocation, monterey:       "bee42d89a9d27667096493fb6fc9ccd03705fcb6d8a38de919737dd327f96fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "579955d51c7beef80999fe96871f9ec4d69976915be2d598af45e15213f5a2f2"
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