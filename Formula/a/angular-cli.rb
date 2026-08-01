class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.1.2.tgz"
  sha256 "f8397bd1b7867249843f625586f57e582df126f6902acb3b19ee1c2ef2a4914b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "637d2d2ee5153f97beacea27371472220bf60ffd35d6d0249e6698d83b8bf528"
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