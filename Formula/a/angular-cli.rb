class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.4.tgz"
  sha256 "5259d1f79575ba9278e6dd7daf984a057d13c25649f896322fb1bf8ebb728ff8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f2227baf58aa9c5d2e1abeef5f8a2ff7dc46ba35e45e6d251a659a93dd353c21"
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