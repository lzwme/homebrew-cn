require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.2.7.tgz"
  sha256 "a0cef4af1082774c5c97b8716a8671806ac7635024f698321255afe5100bcfa8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d799bbddc6843fb8b7fd678fbb5d2119ec00c1ff79792a460cc48d7a863b97bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d799bbddc6843fb8b7fd678fbb5d2119ec00c1ff79792a460cc48d7a863b97bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d799bbddc6843fb8b7fd678fbb5d2119ec00c1ff79792a460cc48d7a863b97bc"
    sha256 cellar: :any_skip_relocation, ventura:        "8dcbdd88b905a4ed9241ab70fb4a121a0da3ab158013bff3d629b460782eb607"
    sha256 cellar: :any_skip_relocation, monterey:       "8dcbdd88b905a4ed9241ab70fb4a121a0da3ab158013bff3d629b460782eb607"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dcbdd88b905a4ed9241ab70fb4a121a0da3ab158013bff3d629b460782eb607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d799bbddc6843fb8b7fd678fbb5d2119ec00c1ff79792a460cc48d7a863b97bc"
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