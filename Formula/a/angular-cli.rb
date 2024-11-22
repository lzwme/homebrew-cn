class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.0.1.tgz"
  sha256 "1630af91a6f47dec7ff59899a069eeba80f2a499f4767962a26d592b70253002"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "812b462ab4a5554e18aa61af74f69efbaab9e15ac32eaa3c58634e4800a247a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "812b462ab4a5554e18aa61af74f69efbaab9e15ac32eaa3c58634e4800a247a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "812b462ab4a5554e18aa61af74f69efbaab9e15ac32eaa3c58634e4800a247a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c10b15b9a4ce6fa703f407b6d048d72c6ca7f4c7f2bfbd60544b96a487cc8575"
    sha256 cellar: :any_skip_relocation, ventura:       "c10b15b9a4ce6fa703f407b6d048d72c6ca7f4c7f2bfbd60544b96a487cc8575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "812b462ab4a5554e18aa61af74f69efbaab9e15ac32eaa3c58634e4800a247a7"
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