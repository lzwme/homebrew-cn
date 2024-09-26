class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.6.tgz"
  sha256 "7b2dbf5c4033c6282aaa9b79068d55da7c9364b17a7c1dbc81847fc217ecda05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9e07f024e16f3ceca3f3ab8b349ff1ce63b4eece1840f053f9599874599556a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e07f024e16f3ceca3f3ab8b349ff1ce63b4eece1840f053f9599874599556a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e07f024e16f3ceca3f3ab8b349ff1ce63b4eece1840f053f9599874599556a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "20133cbf4b3dc48e987f6a8cfe1c17c73dae9efb9e3c47b262e83eaf8ac57478"
    sha256 cellar: :any_skip_relocation, ventura:       "20133cbf4b3dc48e987f6a8cfe1c17c73dae9efb9e3c47b262e83eaf8ac57478"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e07f024e16f3ceca3f3ab8b349ff1ce63b4eece1840f053f9599874599556a1"
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