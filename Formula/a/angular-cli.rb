class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.5.tgz"
  sha256 "39d9a78848155cc81b97a4f3e46269b8c6d587afb2a93d56bb4edf09c43b9858"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec9fe8fdfcb7cddc42a9071d9fc4eb92959fb029d1e4e8458efbf9a094e92a26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec9fe8fdfcb7cddc42a9071d9fc4eb92959fb029d1e4e8458efbf9a094e92a26"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec9fe8fdfcb7cddc42a9071d9fc4eb92959fb029d1e4e8458efbf9a094e92a26"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e15d9ff87908dc15748286f6f65f8ef14d7825bd743bc24840075baf663acd6"
    sha256 cellar: :any_skip_relocation, ventura:       "5e15d9ff87908dc15748286f6f65f8ef14d7825bd743bc24840075baf663acd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec9fe8fdfcb7cddc42a9071d9fc4eb92959fb029d1e4e8458efbf9a094e92a26"
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