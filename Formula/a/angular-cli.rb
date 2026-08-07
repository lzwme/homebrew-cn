class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.1.3.tgz"
  sha256 "b24e14c18678e042da07707aeb55ed2ae77c0bd7b33c18b9d492b59773188c2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "360cffb00a1fba7afbb18140eb54c0395cef569251bdef16109e874e9300de2a"
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