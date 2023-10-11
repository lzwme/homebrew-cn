require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.133.0.tgz"
  sha256 "ee7dc79a1e84444d26b16908890dec8a080fae2f3659b7c3d487f6b8682905e3"
  license "Apache-2.0"
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "57bc67018acde931e78f791b25783bf5f13297682a8d86cf06ca36cc568de50d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57bc67018acde931e78f791b25783bf5f13297682a8d86cf06ca36cc568de50d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57bc67018acde931e78f791b25783bf5f13297682a8d86cf06ca36cc568de50d"
    sha256 cellar: :any_skip_relocation, sonoma:         "bdf10b42afc735dfab1dce52035bd6cc005808614153879dfe3f04709da7e405"
    sha256 cellar: :any_skip_relocation, ventura:        "bdf10b42afc735dfab1dce52035bd6cc005808614153879dfe3f04709da7e405"
    sha256 cellar: :any_skip_relocation, monterey:       "bdf10b42afc735dfab1dce52035bd6cc005808614153879dfe3f04709da7e405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57bc67018acde931e78f791b25783bf5f13297682a8d86cf06ca36cc568de50d"
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