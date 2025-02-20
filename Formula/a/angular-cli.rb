class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.8.tgz"
  sha256 "00c3f2202139216a3694772835a53e253966ea5e6174c8a9dbe6210e405f1153"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "615ccbe73268452129bbef45ef323c8d8e4cb06cfa13a4652e5d1c167b5cbce7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "615ccbe73268452129bbef45ef323c8d8e4cb06cfa13a4652e5d1c167b5cbce7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "615ccbe73268452129bbef45ef323c8d8e4cb06cfa13a4652e5d1c167b5cbce7"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeba854c136fb496121b5df57f24bde63e30d22c09e9221fd6c0f342b17d0c32"
    sha256 cellar: :any_skip_relocation, ventura:       "eeba854c136fb496121b5df57f24bde63e30d22c09e9221fd6c0f342b17d0c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "615ccbe73268452129bbef45ef323c8d8e4cb06cfa13a4652e5d1c167b5cbce7"
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