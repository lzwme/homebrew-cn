require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.109.0.tgz"
  sha256 "fe958d60949d224ffad32104c090061ce816d30fd824c93678271be83bf4d2f7"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "44938dcbb65761799e31ab1be61d09513538356616218f25c265e7600fa31e75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44938dcbb65761799e31ab1be61d09513538356616218f25c265e7600fa31e75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44938dcbb65761799e31ab1be61d09513538356616218f25c265e7600fa31e75"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba8b4a90f94ecb45779b019ece1f63aec36b598728df326cc3a164056cebbb70"
    sha256 cellar: :any_skip_relocation, ventura:        "ba8b4a90f94ecb45779b019ece1f63aec36b598728df326cc3a164056cebbb70"
    sha256 cellar: :any_skip_relocation, monterey:       "ba8b4a90f94ecb45779b019ece1f63aec36b598728df326cc3a164056cebbb70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44938dcbb65761799e31ab1be61d09513538356616218f25c265e7600fa31e75"
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