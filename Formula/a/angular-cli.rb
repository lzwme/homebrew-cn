class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.1.6.tgz"
  sha256 "d457e0664fce0c2ad0ca495e85dbb1752f38b1cd4f20816384fe4dc84b74ca7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "489c583038ad9f3dac1b1be6f9364dcf73c40a9a5b82849d74ad7aea62e9c3e3"
    sha256 cellar: :any_skip_relocation, ventura:       "489c583038ad9f3dac1b1be6f9364dcf73c40a9a5b82849d74ad7aea62e9c3e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "927c788cc5240f18b1b64f71cd25b3552d34cafbe2b05103f7e3c2a3b13678a9"
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