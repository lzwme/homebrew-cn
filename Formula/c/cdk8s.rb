require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.28.tgz"
  sha256 "eb067dde05e864cb6ce0bb176a9520110ae760d4cbe62feb71b24115cd346b75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0135da6b08fbeb0a26b180452fe4dcdbc89940984fd0c57c0a4dae4f53745d65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0135da6b08fbeb0a26b180452fe4dcdbc89940984fd0c57c0a4dae4f53745d65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0135da6b08fbeb0a26b180452fe4dcdbc89940984fd0c57c0a4dae4f53745d65"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7469aa55b9408d69da09ca3ccbaaa87971e974bfe0f849bd2ecf0b1da8bb572"
    sha256 cellar: :any_skip_relocation, ventura:        "d7469aa55b9408d69da09ca3ccbaaa87971e974bfe0f849bd2ecf0b1da8bb572"
    sha256 cellar: :any_skip_relocation, monterey:       "d7469aa55b9408d69da09ca3ccbaaa87971e974bfe0f849bd2ecf0b1da8bb572"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0135da6b08fbeb0a26b180452fe4dcdbc89940984fd0c57c0a4dae4f53745d65"
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