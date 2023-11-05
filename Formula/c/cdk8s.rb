require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.166.0.tgz"
  sha256 "9586258c16da19195c72e0a0722dc51d7584e7654a7645e4b42db53c03689d9b"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0e7290a15941197bd689891e3a9ed469c7d0b5f5c9c5ac8bdeaa2b280679ace"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0e7290a15941197bd689891e3a9ed469c7d0b5f5c9c5ac8bdeaa2b280679ace"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0e7290a15941197bd689891e3a9ed469c7d0b5f5c9c5ac8bdeaa2b280679ace"
    sha256 cellar: :any_skip_relocation, sonoma:         "26342e8f9796742abeebe9c0c56c7dda5e45b0bd6d14e6a8bf731b066454d159"
    sha256 cellar: :any_skip_relocation, ventura:        "26342e8f9796742abeebe9c0c56c7dda5e45b0bd6d14e6a8bf731b066454d159"
    sha256 cellar: :any_skip_relocation, monterey:       "26342e8f9796742abeebe9c0c56c7dda5e45b0bd6d14e6a8bf731b066454d159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0e7290a15941197bd689891e3a9ed469c7d0b5f5c9c5ac8bdeaa2b280679ace"
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