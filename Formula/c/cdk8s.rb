require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.1.tgz"
  sha256 "547f4ce0a0096672787065265fc661487ae5ff5e258c4d60f2f7123c2dcfa636"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75f86772633cea1b48b00b8b40176491a108cd7f26bfaef32c6fa234261d4dcb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75f86772633cea1b48b00b8b40176491a108cd7f26bfaef32c6fa234261d4dcb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75f86772633cea1b48b00b8b40176491a108cd7f26bfaef32c6fa234261d4dcb"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d19df49c505feadf048d51727e44d9dfdf4c84fc584ebf04e364f1046d39d0f"
    sha256 cellar: :any_skip_relocation, ventura:        "1d19df49c505feadf048d51727e44d9dfdf4c84fc584ebf04e364f1046d39d0f"
    sha256 cellar: :any_skip_relocation, monterey:       "1d19df49c505feadf048d51727e44d9dfdf4c84fc584ebf04e364f1046d39d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75f86772633cea1b48b00b8b40176491a108cd7f26bfaef32c6fa234261d4dcb"
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