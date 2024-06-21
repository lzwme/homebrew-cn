require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.0.5.tgz"
  sha256 "3b3ce1444a0b34e8692fc0ea61c71a89af03a3b3eeb643c2e4d97d26e39e67b6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16cda2c44bcb071c6a70b54af1092ddc85acdfc16f6fdb88d813a8f95012f097"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16cda2c44bcb071c6a70b54af1092ddc85acdfc16f6fdb88d813a8f95012f097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16cda2c44bcb071c6a70b54af1092ddc85acdfc16f6fdb88d813a8f95012f097"
    sha256 cellar: :any_skip_relocation, sonoma:         "062c26612f67fecafdcdbdf4ea65bb15b474fee7358f086bdd5a37f112d06c09"
    sha256 cellar: :any_skip_relocation, ventura:        "062c26612f67fecafdcdbdf4ea65bb15b474fee7358f086bdd5a37f112d06c09"
    sha256 cellar: :any_skip_relocation, monterey:       "062c26612f67fecafdcdbdf4ea65bb15b474fee7358f086bdd5a37f112d06c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74028aeea59634df09b5daef11fb306c1d193490ea825b0a78ea280f51fab536"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end