require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.2.5.tgz"
  sha256 "4712c8d7fa2b65cdff092a6bfee225039b0b1ad111082f3edd8cdc3ca72090d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf70adc5074d90d1018aff54bbfd84c0bf09aa692aef257c27beb6ecf6d10b79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf70adc5074d90d1018aff54bbfd84c0bf09aa692aef257c27beb6ecf6d10b79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf70adc5074d90d1018aff54bbfd84c0bf09aa692aef257c27beb6ecf6d10b79"
    sha256 cellar: :any_skip_relocation, ventura:        "c1a6a8b87a21f87ae4d9c7013703816e4a9706192ad9cd1f715023c38d764509"
    sha256 cellar: :any_skip_relocation, monterey:       "c1a6a8b87a21f87ae4d9c7013703816e4a9706192ad9cd1f715023c38d764509"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1a6a8b87a21f87ae4d9c7013703816e4a9706192ad9cd1f715023c38d764509"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf70adc5074d90d1018aff54bbfd84c0bf09aa692aef257c27beb6ecf6d10b79"
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