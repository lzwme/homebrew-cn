require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.125.tgz"
  sha256 "539860ecf2ce7bd891e1be1e0e9317c4faa7e861f8c7936d5b3c489a06ebf3dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef78f40071fa2b6d56ff99b95f7d0b3a08866fd2b19cf57d699e87ebe99f89bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25768f1dcdec2343dd51b8a40856f02003f4f49caccd0a03353792b3d8563359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7db600b77bb82251dd73a90fc76bbe33d9690e0e7238654e35f19bb5b2e91349"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d078d6bcbe779cf9176707915242b61ed69935b0c6f65586e1820a33532e5d6"
    sha256 cellar: :any_skip_relocation, ventura:        "ab6ca8102c0001c9b520b4a6bdf211c2c7ad6e2d35403a59688c8c1ff7621449"
    sha256 cellar: :any_skip_relocation, monterey:       "86e7419670064c8de40b505a07bc4971e75fce3a989c8c7d9079c71442d4f3cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c984d3eb978ec141d45754dc210965b64a906c9048d1120c09318d53082320b4"
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