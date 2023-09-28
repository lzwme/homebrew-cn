require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.4.tgz"
  sha256 "4bd8f93b29fd1132f0c600060e3b19eb9f469b53eb875e86ce3dd5f9586ab8ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fe6998e2fea66cda6a6288854caddfa635dba85c47a367923d4bbf5ebbfd2d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fe6998e2fea66cda6a6288854caddfa635dba85c47a367923d4bbf5ebbfd2d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fe6998e2fea66cda6a6288854caddfa635dba85c47a367923d4bbf5ebbfd2d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2d7b476eec67cb3dc32e2f06d8bbf90bcf07c6c6060bcf62af4189938be44e8"
    sha256 cellar: :any_skip_relocation, ventura:        "a2d7b476eec67cb3dc32e2f06d8bbf90bcf07c6c6060bcf62af4189938be44e8"
    sha256 cellar: :any_skip_relocation, monterey:       "97053fb6f5eceb444ec993b10a8ec907d47bb7da173c15263ca282c0a9e2e21a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fe6998e2fea66cda6a6288854caddfa635dba85c47a367923d4bbf5ebbfd2d2"
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