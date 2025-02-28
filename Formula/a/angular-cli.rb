class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.0.tgz"
  sha256 "d6b60817ff0debacd9bf800482334e85decf121564a51af65f3f6ae5cf9c9c63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec1a5baffc3569d4e9ebcc0dd9cdae18be8529fbdedb9284cb65e4d831a2501b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec1a5baffc3569d4e9ebcc0dd9cdae18be8529fbdedb9284cb65e4d831a2501b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec1a5baffc3569d4e9ebcc0dd9cdae18be8529fbdedb9284cb65e4d831a2501b"
    sha256 cellar: :any_skip_relocation, sonoma:        "23999b30a6905e5f83530a353323d15ba624234f1741d3b9275f497e0028ece8"
    sha256 cellar: :any_skip_relocation, ventura:       "23999b30a6905e5f83530a353323d15ba624234f1741d3b9275f497e0028ece8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec1a5baffc3569d4e9ebcc0dd9cdae18be8529fbdedb9284cb65e4d831a2501b"
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