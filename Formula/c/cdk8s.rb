require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.123.0.tgz"
  sha256 "73fea525bcd4cb88266303d904b2568919d659738969d319b6215fdfa1eb2553"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "83c292dde2e8fdef6827ad5d0ce0f30c9460c340ea171a7dee32b7ec1b843183"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83c292dde2e8fdef6827ad5d0ce0f30c9460c340ea171a7dee32b7ec1b843183"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83c292dde2e8fdef6827ad5d0ce0f30c9460c340ea171a7dee32b7ec1b843183"
    sha256 cellar: :any_skip_relocation, sonoma:         "a7508c6f9e0c623220ae5836fa83bf1c7f237219ac74cf515e92f6c76840b293"
    sha256 cellar: :any_skip_relocation, ventura:        "a7508c6f9e0c623220ae5836fa83bf1c7f237219ac74cf515e92f6c76840b293"
    sha256 cellar: :any_skip_relocation, monterey:       "a7508c6f9e0c623220ae5836fa83bf1c7f237219ac74cf515e92f6c76840b293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83c292dde2e8fdef6827ad5d0ce0f30c9460c340ea171a7dee32b7ec1b843183"
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