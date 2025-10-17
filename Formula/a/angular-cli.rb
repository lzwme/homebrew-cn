class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.3.6.tgz"
  sha256 "e06d1dd8a1f15edc69aa6309a6d65176600c2efb8b1d49588bafc0db1e70a5a2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a206ddf0f0971a42857cdcbbbd4eece2f5295ee0721db1684570c89672d467bd"
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