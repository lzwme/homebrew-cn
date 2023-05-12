require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.0.1.tgz"
  sha256 "327e8bc18feae047f2938fd1a1e2a0791a4b2bb006f8241a6bc63181e4800464"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6faf89d41f81355e63dc16272d607d3a843d9e29f7eb9d2f95d2724e49d228d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6faf89d41f81355e63dc16272d607d3a843d9e29f7eb9d2f95d2724e49d228d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6faf89d41f81355e63dc16272d607d3a843d9e29f7eb9d2f95d2724e49d228d6"
    sha256 cellar: :any_skip_relocation, ventura:        "d98ef0a63ecd4411abb650b50ca4646808690e79fcae5b3e163edbccc889fc38"
    sha256 cellar: :any_skip_relocation, monterey:       "d98ef0a63ecd4411abb650b50ca4646808690e79fcae5b3e163edbccc889fc38"
    sha256 cellar: :any_skip_relocation, big_sur:        "d98ef0a63ecd4411abb650b50ca4646808690e79fcae5b3e163edbccc889fc38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6faf89d41f81355e63dc16272d607d3a843d9e29f7eb9d2f95d2724e49d228d6"
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