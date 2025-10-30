class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.8.tgz"
  sha256 "cc542c8c10e7e28b0c631eb7c2ae78cf419aba6e2fe522fd0b2bdb21c620dea8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46dd6f375e8b8bc4166fe05f2296b154942487b06f9f95e0b7b7a8a8bc89e0cc"
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