class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.5.tgz"
  sha256 "7e5a14d26de3f14e3348b8aafb817aca378fae4613b4aefef867e9cd3258519b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9a33507cb934accaecc764cea9c4feda6419714e5aeea94315326c70f424714c"
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