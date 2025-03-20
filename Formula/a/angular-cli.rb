class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.4.tgz"
  sha256 "916fd4c07e2a714476708dd50cab9db37c386720a6ef9b4fbfcff7ac6835dc37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8b18c4eaece6edb85332fbead25844e2df201f9b81bf0dc8aeb612fd753b2fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b8b18c4eaece6edb85332fbead25844e2df201f9b81bf0dc8aeb612fd753b2fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b8b18c4eaece6edb85332fbead25844e2df201f9b81bf0dc8aeb612fd753b2fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1431752075066b39e92c2ce85b04acd2a5143f68bcff5d78bb9f4bb6502371a5"
    sha256 cellar: :any_skip_relocation, ventura:       "1431752075066b39e92c2ce85b04acd2a5143f68bcff5d78bb9f4bb6502371a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8b18c4eaece6edb85332fbead25844e2df201f9b81bf0dc8aeb612fd753b2fa"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end