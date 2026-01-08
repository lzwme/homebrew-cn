class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.0.5.tgz"
  sha256 "70ba1063ab96020aff80c05ef2844fa9be315e0c929ad2fb8d5cad6ff55c4891"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15f70a1e6537c5c962fccf18272190a3ca71034e7e1ca464a12d6dd2780ca13c"
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