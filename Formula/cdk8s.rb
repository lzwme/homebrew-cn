require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.28.tgz"
  sha256 "82afa695270a6ab1f4e32d46e58b8f1094b5c6dd7cef53fb20c8803e21d6552d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34d7229cd684eb08414ddf51aa2c7dd9907a5ccc89429abadc141b4045c895e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34d7229cd684eb08414ddf51aa2c7dd9907a5ccc89429abadc141b4045c895e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34d7229cd684eb08414ddf51aa2c7dd9907a5ccc89429abadc141b4045c895e4"
    sha256 cellar: :any_skip_relocation, ventura:        "268c8d3d8ae1041e5447a5a59231dccb03bb0c98e86760f34464cba39f4cc8bc"
    sha256 cellar: :any_skip_relocation, monterey:       "268c8d3d8ae1041e5447a5a59231dccb03bb0c98e86760f34464cba39f4cc8bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "268c8d3d8ae1041e5447a5a59231dccb03bb0c98e86760f34464cba39f4cc8bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34d7229cd684eb08414ddf51aa2c7dd9907a5ccc89429abadc141b4045c895e4"
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