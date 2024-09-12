class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.4.tgz"
  sha256 "a5c3a2e55942d2e63e8000a031c39d917b1f46758096a35b2d52a196f05804d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "004d3c08a9a47c1e3a995d8332806f081237aec54ddb0348555b38d8aefd0845"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "004d3c08a9a47c1e3a995d8332806f081237aec54ddb0348555b38d8aefd0845"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "004d3c08a9a47c1e3a995d8332806f081237aec54ddb0348555b38d8aefd0845"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "004d3c08a9a47c1e3a995d8332806f081237aec54ddb0348555b38d8aefd0845"
    sha256 cellar: :any_skip_relocation, sonoma:         "2cb56d00a2a8c7c3ae5157e35f541d75899ac29db3f8890e6544608806a2c105"
    sha256 cellar: :any_skip_relocation, ventura:        "2cb56d00a2a8c7c3ae5157e35f541d75899ac29db3f8890e6544608806a2c105"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb56d00a2a8c7c3ae5157e35f541d75899ac29db3f8890e6544608806a2c105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "004d3c08a9a47c1e3a995d8332806f081237aec54ddb0348555b38d8aefd0845"
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