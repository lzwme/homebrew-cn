require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.170.tgz"
  sha256 "5f13f8e9c765227c51f9cf2f87d5503cc02da8442bb7a46a5aed321479d91e97"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b980de8dacdb42745689867f09e3801a499a9f6fcb5c1cca3dd32f6bddd87857"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b980de8dacdb42745689867f09e3801a499a9f6fcb5c1cca3dd32f6bddd87857"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b980de8dacdb42745689867f09e3801a499a9f6fcb5c1cca3dd32f6bddd87857"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb69439012faec3aab14900b5d16b7f67a0afa9ad7b91ec82ad1fd56e58c0fa9"
    sha256 cellar: :any_skip_relocation, ventura:        "bb69439012faec3aab14900b5d16b7f67a0afa9ad7b91ec82ad1fd56e58c0fa9"
    sha256 cellar: :any_skip_relocation, monterey:       "bb69439012faec3aab14900b5d16b7f67a0afa9ad7b91ec82ad1fd56e58c0fa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc732e41df89976e5448c4f9df042f02ed5ffb4dff900500019d1c6624df2555"
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