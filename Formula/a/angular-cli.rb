class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.1.4.tgz"
  sha256 "e71e56e4a449a486f003457815a42df8f9effdfdc4f52b5b5387230c548bb9b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15687c434a5f2bdfd7c6e95fe04fc7e73689043fd80e81fd64a97d7638f9c099"
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