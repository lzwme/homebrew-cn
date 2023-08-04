require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.19.0.tgz"
  sha256 "3ed8aa552a2587d6c8b3b6dec66a67318aaa405f7d6e6b82cc9500ce63477cc9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b41c5d94f73e36535032eaf030f185b07c016dce4c583e19808bf3c02d17b5d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b41c5d94f73e36535032eaf030f185b07c016dce4c583e19808bf3c02d17b5d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b41c5d94f73e36535032eaf030f185b07c016dce4c583e19808bf3c02d17b5d7"
    sha256 cellar: :any_skip_relocation, ventura:        "3d24e37c1d4d42a8855bc7b10234f52180fc30ffdcc5596c75ef3431308c7e90"
    sha256 cellar: :any_skip_relocation, monterey:       "3d24e37c1d4d42a8855bc7b10234f52180fc30ffdcc5596c75ef3431308c7e90"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d24e37c1d4d42a8855bc7b10234f52180fc30ffdcc5596c75ef3431308c7e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4204d5345b765035a800999f865bf360151ec6150dae5b787ec80d20d4f258"
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