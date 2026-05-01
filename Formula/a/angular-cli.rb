class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.9.tgz"
  sha256 "530fdc9da17cb3c9134b2713941c7161e51629c6a53e47a72baeeea2755e065e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6ffaf67eba7048a76b387f1f45b633aba972f4a7bcd9f4ab39b21749cafffe2b"
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