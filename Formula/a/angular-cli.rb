class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.7.tgz"
  sha256 "6ae8946affaa36f5cc5e36c8b96cae782ae4beefec9f7320a034651e3fe7680c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "67ab20f2a9baa72cf0045375081079fd4fb2b355af6c5fc38bb6d355900f4a8e"
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