require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.8.tgz"
  sha256 "ead3c24328be92029b4738012726a7d04bde667d85d945ec5123c912f4305f3b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7998e28369e75bda55edbf9e9f3a07764a1f0672ed0818d3e881d6110be697e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7998e28369e75bda55edbf9e9f3a07764a1f0672ed0818d3e881d6110be697e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7998e28369e75bda55edbf9e9f3a07764a1f0672ed0818d3e881d6110be697e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fdb1be51738d949189193af50f83f940343dcb6825d7975c463c73cc2f7d0803"
    sha256 cellar: :any_skip_relocation, ventura:        "fdb1be51738d949189193af50f83f940343dcb6825d7975c463c73cc2f7d0803"
    sha256 cellar: :any_skip_relocation, monterey:       "fdb1be51738d949189193af50f83f940343dcb6825d7975c463c73cc2f7d0803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7998e28369e75bda55edbf9e9f3a07764a1f0672ed0818d3e881d6110be697e"
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