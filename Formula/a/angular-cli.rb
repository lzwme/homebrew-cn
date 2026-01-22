class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.1.1.tgz"
  sha256 "2d31ae70b1a4a61aa3debb765b99cf192fb18243e117b26de1e3f3da96a4c288"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c6d8beeff9afd82c4c531d0ef197237dbe3aadb95d7fb55626219b34a1bac51"
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