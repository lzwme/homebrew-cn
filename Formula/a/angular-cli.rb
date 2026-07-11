class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.6.tgz"
  sha256 "66ba6d196671a98d8b87057c0913a39b78547b45ec668596a448bbb1b3fe7e8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a7bc0adbda476071ed811c5b863b0424c1bf3adafc89086ba11d7fe4bd85e29"
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