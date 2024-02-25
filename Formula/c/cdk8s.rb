require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.56.tgz"
  sha256 "5b9abe65433ee68ab26473336eb198689dc7a47aa9a3ebd86f2e10ea27b24f7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fa60036378c759a677f6cab3b332d5d9397d72f45739ea4c16454c9349a5bb9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fa60036378c759a677f6cab3b332d5d9397d72f45739ea4c16454c9349a5bb9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fa60036378c759a677f6cab3b332d5d9397d72f45739ea4c16454c9349a5bb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9641e7ebb0125713150997cf7c01f289c2839a3759746e6f7e5ca069252d1c6"
    sha256 cellar: :any_skip_relocation, ventura:        "d9641e7ebb0125713150997cf7c01f289c2839a3759746e6f7e5ca069252d1c6"
    sha256 cellar: :any_skip_relocation, monterey:       "d9641e7ebb0125713150997cf7c01f289c2839a3759746e6f7e5ca069252d1c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fa60036378c759a677f6cab3b332d5d9397d72f45739ea4c16454c9349a5bb9"
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