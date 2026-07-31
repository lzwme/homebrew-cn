class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.9.tgz"
  sha256 "2b1d1c8b5151b22db80ff926e7aae445fe6b837374289df7dd185b55acb5abf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b4e0fce6462ceed8c3966f80f14420a7bc619ea8cba97f77ce92f88e726102a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end