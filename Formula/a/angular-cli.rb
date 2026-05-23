class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.12.tgz"
  sha256 "59c07ead7f418ce1fe1c5117534b4d45d65e2894b4c83b6dfc4529c36f42ace2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d865872390f3be786a3c9981add4e08aefc1a5c7129d083e938c82dc3f2ad310"
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