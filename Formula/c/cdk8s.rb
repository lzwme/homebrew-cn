require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.153.0.tgz"
  sha256 "c5be71ee081aee4fa0df9b17739ea455a6b0bbbfb9bb19427b382ae287219f84"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "129960fd9ee9a9538e6537aaec51f4f85ebda9e8dda133666ba6854b1c279f95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "129960fd9ee9a9538e6537aaec51f4f85ebda9e8dda133666ba6854b1c279f95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "129960fd9ee9a9538e6537aaec51f4f85ebda9e8dda133666ba6854b1c279f95"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f6563e67d842fb74e4b19742ac7c082bbbb8efbcba623556ed0dbcb13949633"
    sha256 cellar: :any_skip_relocation, ventura:        "1f6563e67d842fb74e4b19742ac7c082bbbb8efbcba623556ed0dbcb13949633"
    sha256 cellar: :any_skip_relocation, monterey:       "1f6563e67d842fb74e4b19742ac7c082bbbb8efbcba623556ed0dbcb13949633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129960fd9ee9a9538e6537aaec51f4f85ebda9e8dda133666ba6854b1c279f95"
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