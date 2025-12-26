class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.0.4.tgz"
  sha256 "6480c53e74516c28cb1a5b50af98ba1ceda74f69daefce1a463c949a0f573104"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae42eb97fa52ffb66667fc803ab2c859dcc2a9bed10af24d61ebb08a44c4145d"
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