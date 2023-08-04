require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.1.7.tgz"
  sha256 "1bac848be86622a82244a63b4df38e98c67bd24cf09d1406c6de6b1e7151da55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d33536ac504005096d99ff6e8597a9cb193f2f9c6fe135f7f7ec951cfb1005d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d33536ac504005096d99ff6e8597a9cb193f2f9c6fe135f7f7ec951cfb1005d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5d33536ac504005096d99ff6e8597a9cb193f2f9c6fe135f7f7ec951cfb1005d"
    sha256 cellar: :any_skip_relocation, ventura:        "f3ff95257e0a010b5df7fee26ce5fc23f2411d3dc1635ffc289f57b87f017698"
    sha256 cellar: :any_skip_relocation, monterey:       "f3ff95257e0a010b5df7fee26ce5fc23f2411d3dc1635ffc289f57b87f017698"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3ff95257e0a010b5df7fee26ce5fc23f2411d3dc1635ffc289f57b87f017698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6235632c47a819efe1e694a22d064ec8ef663f506f6aa6844ff171c5dea6ca97"
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