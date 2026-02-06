class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-21.1.3.tgz"
  sha256 "0bd9e4d8ffbb696ad70a1d9e84e57c6e7d7e5e36c107e392a72c810c9552ea06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "468bfb843db4ee65440ba67edf5d87c777325a604a36868fb6dec3da74053789"
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