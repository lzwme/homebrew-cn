class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.13.tgz"
  sha256 "7e522483544bac61c6939d0fddf45d7a41fdf6fddd585c3101f0d96e85fb2ae3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bb0037d3ad8a564c846e3b74e1c9f49da53d14b6479f4b40044d9947ca5aa28"
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