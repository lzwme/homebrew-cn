require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.131.0.tgz"
  sha256 "a0292e60c26034a1e227892bf70fb64e227261f3e7c113f7ca639a5b78d5cdae"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dbcec028d1cb39e571717d61d2bd05f9c7f76a0bdeaebb68965b4c280d283c73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbcec028d1cb39e571717d61d2bd05f9c7f76a0bdeaebb68965b4c280d283c73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbcec028d1cb39e571717d61d2bd05f9c7f76a0bdeaebb68965b4c280d283c73"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3a52feb8c5abd8b7d9ae344d240d443c901cd505d67f759e91a0759a3f17b97"
    sha256 cellar: :any_skip_relocation, ventura:        "c3a52feb8c5abd8b7d9ae344d240d443c901cd505d67f759e91a0759a3f17b97"
    sha256 cellar: :any_skip_relocation, monterey:       "c3a52feb8c5abd8b7d9ae344d240d443c901cd505d67f759e91a0759a3f17b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbcec028d1cb39e571717d61d2bd05f9c7f76a0bdeaebb68965b4c280d283c73"
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