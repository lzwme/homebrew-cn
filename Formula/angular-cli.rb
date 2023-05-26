require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.0.3.tgz"
  sha256 "f91aa883a95e240bf650baf06db5d2763dd6eef2c45d9b9b36f089037aa3f0ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ebefb2ae9496e6450df83ba69fae8f31880472e16c91703d637d2718eef1299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ebefb2ae9496e6450df83ba69fae8f31880472e16c91703d637d2718eef1299"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ebefb2ae9496e6450df83ba69fae8f31880472e16c91703d637d2718eef1299"
    sha256 cellar: :any_skip_relocation, ventura:        "6a0e33c561ab837eab209fbdba3e873246c49e6778953202fc0649f633f004d1"
    sha256 cellar: :any_skip_relocation, monterey:       "6a0e33c561ab837eab209fbdba3e873246c49e6778953202fc0649f633f004d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a0e33c561ab837eab209fbdba3e873246c49e6778953202fc0649f633f004d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ebefb2ae9496e6450df83ba69fae8f31880472e16c91703d637d2718eef1299"
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