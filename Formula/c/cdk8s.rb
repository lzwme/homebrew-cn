require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.175.tgz"
  sha256 "5197c186faab4d26982d3f318d95548b58d3a14086831deafc430b061737f07e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ae78073b90cd6875886dfcf8155b80ab865068cdfce32e0e96a234ecf292463"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ae78073b90cd6875886dfcf8155b80ab865068cdfce32e0e96a234ecf292463"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ae78073b90cd6875886dfcf8155b80ab865068cdfce32e0e96a234ecf292463"
    sha256 cellar: :any_skip_relocation, sonoma:         "abca0122f464bb6bb07d851030f235cf6e74ff0d105a372ccb7e4d99b38af4a3"
    sha256 cellar: :any_skip_relocation, ventura:        "abca0122f464bb6bb07d851030f235cf6e74ff0d105a372ccb7e4d99b38af4a3"
    sha256 cellar: :any_skip_relocation, monterey:       "abca0122f464bb6bb07d851030f235cf6e74ff0d105a372ccb7e4d99b38af4a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6826ec421eae6850dd2dd345fa80847def9f6a0226e2c2a8bbdb4f7caecb9de6"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end