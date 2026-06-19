class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.2.tgz"
  sha256 "96e4163ef73c46be2ddb43f4cb2153d4e2196f72280f35418a899f7ce7c67055"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d79d11c68d40058e5cf7f6f2b896db4ec85abfd3e79b064ac4c34b56c1b14f99"
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