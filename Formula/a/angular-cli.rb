class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.0.0.tgz"
  sha256 "6145dcefea57894b3df9be6ab1b2d887b42933c673f717cf0ef122d2fab0f624"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c8513baf5f7bd4505fea5eca9dbe32a2d1d88f3af5149dc47f6779364ecdcfa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c8513baf5f7bd4505fea5eca9dbe32a2d1d88f3af5149dc47f6779364ecdcfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c8513baf5f7bd4505fea5eca9dbe32a2d1d88f3af5149dc47f6779364ecdcfa"
    sha256 cellar: :any_skip_relocation, sonoma:        "87c20b05a57b82b6bee48b0a0e47fb7dc3dd7fcd906e0e3355ff33c16e5603e1"
    sha256 cellar: :any_skip_relocation, ventura:       "87c20b05a57b82b6bee48b0a0e47fb7dc3dd7fcd906e0e3355ff33c16e5603e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8513baf5f7bd4505fea5eca9dbe32a2d1d88f3af5149dc47f6779364ecdcfa"
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