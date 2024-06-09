require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.140.tgz"
  sha256 "56154caf21ab1e35383c2cc1ab0bf22c80c7941b68bef5416a6a9a4053acafa9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53fcf51fc15f6837ad0730209b46ecdd1431f6bedd63e76976425963938c3d63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53fcf51fc15f6837ad0730209b46ecdd1431f6bedd63e76976425963938c3d63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53fcf51fc15f6837ad0730209b46ecdd1431f6bedd63e76976425963938c3d63"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b4c0bf35d5175c278283607f8819a539bfb6f155d769cbf9ec16f6e84b7c5c4"
    sha256 cellar: :any_skip_relocation, ventura:        "0b4c0bf35d5175c278283607f8819a539bfb6f155d769cbf9ec16f6e84b7c5c4"
    sha256 cellar: :any_skip_relocation, monterey:       "0b4c0bf35d5175c278283607f8819a539bfb6f155d769cbf9ec16f6e84b7c5c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2748e4ea1937e5991f33e16130f2a5caf94042b48c515a4a6665f4fb1a1e9b1"
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