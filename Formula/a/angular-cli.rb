class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.2.0.tgz"
  sha256 "f190fc138d68e5e795757d30ae62dc49b2d4d3292dcf5803c58bb3661d61fda2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "60adc77d92560c2a20a41a5814bf7ce15cd567e97efdadf2627a53f47a251299"
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