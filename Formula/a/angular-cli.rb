class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.2.tgz"
  sha256 "fb7da6a582a8014c64cc41f72528e8f32ef30a8ed979b1a729d455c344a4a68e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0038a67cd852ec65172ad08c211977d445901c28851d409fb88f911a2bd899f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0038a67cd852ec65172ad08c211977d445901c28851d409fb88f911a2bd899f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0038a67cd852ec65172ad08c211977d445901c28851d409fb88f911a2bd899f"
    sha256 cellar: :any_skip_relocation, sonoma:         "80148bacf8f41b7a0c0063aeb2ab1e819aa320d5590e057538ebccd07431ccb4"
    sha256 cellar: :any_skip_relocation, ventura:        "80148bacf8f41b7a0c0063aeb2ab1e819aa320d5590e057538ebccd07431ccb4"
    sha256 cellar: :any_skip_relocation, monterey:       "80148bacf8f41b7a0c0063aeb2ab1e819aa320d5590e057538ebccd07431ccb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0038a67cd852ec65172ad08c211977d445901c28851d409fb88f911a2bd899f"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end