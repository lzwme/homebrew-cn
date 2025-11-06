class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.9.tgz"
  sha256 "43dc32bba83ceb96ce5babe749bb72dea57ee1213bc6db57f4dbf95359da80c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "33cf59a7630ac2be2e606d6ed2f414894547855ac996c7c6a5aa79e2f69e05ad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end