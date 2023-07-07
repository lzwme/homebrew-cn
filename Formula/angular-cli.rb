require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.1.4.tgz"
  sha256 "0c8cb5f6a082f2180c923732d716b97409f49bda6f92eabcb2c2454e117b192b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aed8d5b6ff03da1c3109ce901e5c8d98c57e157cb92fa148480de7b6b13ca8db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aed8d5b6ff03da1c3109ce901e5c8d98c57e157cb92fa148480de7b6b13ca8db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aed8d5b6ff03da1c3109ce901e5c8d98c57e157cb92fa148480de7b6b13ca8db"
    sha256 cellar: :any_skip_relocation, ventura:        "89b37caf109031ba43eb33ae77b14818e546b9e1a3413bebab7d8df88ca3cf19"
    sha256 cellar: :any_skip_relocation, monterey:       "89b37caf109031ba43eb33ae77b14818e546b9e1a3413bebab7d8df88ca3cf19"
    sha256 cellar: :any_skip_relocation, big_sur:        "89b37caf109031ba43eb33ae77b14818e546b9e1a3413bebab7d8df88ca3cf19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aed8d5b6ff03da1c3109ce901e5c8d98c57e157cb92fa148480de7b6b13ca8db"
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