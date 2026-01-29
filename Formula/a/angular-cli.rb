class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.1.2.tgz"
  sha256 "563db766ea8773b90ecfa8f365ad5c3c8964ec5bda44aca6d9968fdb1452a894"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c0d520caf124df5b2a4bcbe6c70dcb099749f9fc5e2710a3569d055abf54bf1f"
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