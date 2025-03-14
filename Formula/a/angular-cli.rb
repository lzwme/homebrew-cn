class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.3.tgz"
  sha256 "fbbdd78f1794b0bf33ea62bc940f5e253d3e38d1cc7a85ec56597808ff3677de"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4301b47c24be58c7dd4f9ce6ebc129d43c22f3bbc572b76e248b9fbe9af6f979"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4301b47c24be58c7dd4f9ce6ebc129d43c22f3bbc572b76e248b9fbe9af6f979"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4301b47c24be58c7dd4f9ce6ebc129d43c22f3bbc572b76e248b9fbe9af6f979"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3f43400c8786dc4b181a6acf7f70a92d17499f65202a1d55624bee5f4bb3562"
    sha256 cellar: :any_skip_relocation, ventura:       "c3f43400c8786dc4b181a6acf7f70a92d17499f65202a1d55624bee5f4bb3562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4301b47c24be58c7dd4f9ce6ebc129d43c22f3bbc572b76e248b9fbe9af6f979"
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