class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.0.tgz"
  sha256 "c1aa16820c78dfd6cf01e1f4e70143a6c09543940744123f2caecf7752d9a931"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "146415599c7b17539a01147a29b883bdb3afe5333219b9b752dc7ceaf292521b"
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