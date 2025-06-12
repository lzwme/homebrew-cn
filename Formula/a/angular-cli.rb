class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.0.2.tgz"
  sha256 "b174fc767d1e3507108df8c190b90783f5fa91375966192565db704f40dec3ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1beb5df0b92ee18e12b2b8ee119f7447f1c4bd0a81a2abb907707ab09138cc1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1beb5df0b92ee18e12b2b8ee119f7447f1c4bd0a81a2abb907707ab09138cc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c1beb5df0b92ee18e12b2b8ee119f7447f1c4bd0a81a2abb907707ab09138cc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "11a68cf4964052150d376f7d354a348e81acb107dd20743e16db4d13bfbf3c2d"
    sha256 cellar: :any_skip_relocation, ventura:       "11a68cf4964052150d376f7d354a348e81acb107dd20743e16db4d13bfbf3c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1beb5df0b92ee18e12b2b8ee119f7447f1c4bd0a81a2abb907707ab09138cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1beb5df0b92ee18e12b2b8ee119f7447f1c4bd0a81a2abb907707ab09138cc1"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end