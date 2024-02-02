require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.1.2.tgz"
  sha256 "63fdcd191b6a97b39020569b1a258ccc121415362263d6ee5cd4315489cb72e6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "568232c389f1b0450c0e744b1c032a7483ba4316823f91e2b8d95c39135ef650"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "568232c389f1b0450c0e744b1c032a7483ba4316823f91e2b8d95c39135ef650"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "568232c389f1b0450c0e744b1c032a7483ba4316823f91e2b8d95c39135ef650"
    sha256 cellar: :any_skip_relocation, sonoma:         "050d9f732099c19d816886cf7ec48d0a7229196b31af297076ab4f57397d97c1"
    sha256 cellar: :any_skip_relocation, ventura:        "050d9f732099c19d816886cf7ec48d0a7229196b31af297076ab4f57397d97c1"
    sha256 cellar: :any_skip_relocation, monterey:       "050d9f732099c19d816886cf7ec48d0a7229196b31af297076ab4f57397d97c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568232c389f1b0450c0e744b1c032a7483ba4316823f91e2b8d95c39135ef650"
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