class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.2.5.tgz"
  sha256 "dab67b31810de911ade624434785cabeaac3748819daa355386ebc939edaf243"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "967704f48b3a58103a5f1218a3464b1d4daf5a293d14a7226d4a6a2eb611ce76"
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