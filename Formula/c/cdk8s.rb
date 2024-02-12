require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.45.tgz"
  sha256 "b570709dc8ad013fccc1a8dd902ecc3d95d92f601658d7012832604ecf4bfbcd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "756e178c19214de065447d81e9e4db60bda61743c876d0d3ed65372388aa6931"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "756e178c19214de065447d81e9e4db60bda61743c876d0d3ed65372388aa6931"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "756e178c19214de065447d81e9e4db60bda61743c876d0d3ed65372388aa6931"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd7d0456e6deb2d877605f88fc335275f205eec784755d4d375bdccbc3d69e02"
    sha256 cellar: :any_skip_relocation, ventura:        "fd7d0456e6deb2d877605f88fc335275f205eec784755d4d375bdccbc3d69e02"
    sha256 cellar: :any_skip_relocation, monterey:       "fd7d0456e6deb2d877605f88fc335275f205eec784755d4d375bdccbc3d69e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "756e178c19214de065447d81e9e4db60bda61743c876d0d3ed65372388aa6931"
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