require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.3.tgz"
  sha256 "a8c3ff7eb62e83d93eb9f3a828db3d2bd29bf191c3e0aac6ba4b99979610b5e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f574d5ad107ea9bf6ae25362a31ec0a1b5968141df70c2b14a3284d46624944"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f574d5ad107ea9bf6ae25362a31ec0a1b5968141df70c2b14a3284d46624944"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f574d5ad107ea9bf6ae25362a31ec0a1b5968141df70c2b14a3284d46624944"
    sha256 cellar: :any_skip_relocation, sonoma:         "c3c721655a4c4e6b96e132a1fb0669a1fcdf3ad56e762b81849afa5e747ba6f5"
    sha256 cellar: :any_skip_relocation, ventura:        "c3c721655a4c4e6b96e132a1fb0669a1fcdf3ad56e762b81849afa5e747ba6f5"
    sha256 cellar: :any_skip_relocation, monterey:       "c3c721655a4c4e6b96e132a1fb0669a1fcdf3ad56e762b81849afa5e747ba6f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f574d5ad107ea9bf6ae25362a31ec0a1b5968141df70c2b14a3284d46624944"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end