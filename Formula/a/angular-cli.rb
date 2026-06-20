class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.3.tgz"
  sha256 "fa52b32353dafa50b0ea074ee56b63532e9ed1596b192343bea476447c4fceaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bc51e271878f1a596e4e77ce7b66a18b508e7b837d448727073a8d3a9d4f441a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end