require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.25.0.tgz"
  sha256 "353bdfb06e626753809148bea0dfa8269e9ecb03451e20b47d856b552a90829a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d23e2f06638226cf867042d65c71c36a1fd4752f0e89d9c38c875ef4795e4b55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23e2f06638226cf867042d65c71c36a1fd4752f0e89d9c38c875ef4795e4b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d23e2f06638226cf867042d65c71c36a1fd4752f0e89d9c38c875ef4795e4b55"
    sha256 cellar: :any_skip_relocation, ventura:        "1af4baae71069244f63700f19f01907e723c5bf246d408cd3ae4dedf7fd2fd48"
    sha256 cellar: :any_skip_relocation, monterey:       "1af4baae71069244f63700f19f01907e723c5bf246d408cd3ae4dedf7fd2fd48"
    sha256 cellar: :any_skip_relocation, big_sur:        "1af4baae71069244f63700f19f01907e723c5bf246d408cd3ae4dedf7fd2fd48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d23e2f06638226cf867042d65c71c36a1fd4752f0e89d9c38c875ef4795e4b55"
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