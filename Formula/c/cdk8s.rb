require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.59.0.tgz"
  sha256 "592a64bb8097fb7a6b609afeea9ef45c153b5b411da2e94059e89d18ed076f2e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24840bab3966cd8fdf125968ddca903a4a87e9b88be5e42740d0e0afe2ee56fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24840bab3966cd8fdf125968ddca903a4a87e9b88be5e42740d0e0afe2ee56fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24840bab3966cd8fdf125968ddca903a4a87e9b88be5e42740d0e0afe2ee56fe"
    sha256 cellar: :any_skip_relocation, ventura:        "ede727eb8ee67897386dfcc73e1306ffbfef815b1042f593af48325fc8c2716b"
    sha256 cellar: :any_skip_relocation, monterey:       "ede727eb8ee67897386dfcc73e1306ffbfef815b1042f593af48325fc8c2716b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ede727eb8ee67897386dfcc73e1306ffbfef815b1042f593af48325fc8c2716b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24840bab3966cd8fdf125968ddca903a4a87e9b88be5e42740d0e0afe2ee56fe"
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