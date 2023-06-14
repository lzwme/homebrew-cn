require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.0.6.tgz"
  sha256 "3de67618553fd56ef2fd6c7210695263a21cc2fbfc4e454feb8195c60ae273c4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68fcdf919ee541f9389adf15f5aa7b107c4e62f6270b2a99cfc6b71ec9287775"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68fcdf919ee541f9389adf15f5aa7b107c4e62f6270b2a99cfc6b71ec9287775"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68fcdf919ee541f9389adf15f5aa7b107c4e62f6270b2a99cfc6b71ec9287775"
    sha256 cellar: :any_skip_relocation, ventura:        "60b1ad092cbd57edd8e85ba7a045a21f69d8cde88968b8902ce1303f70ea4385"
    sha256 cellar: :any_skip_relocation, monterey:       "60b1ad092cbd57edd8e85ba7a045a21f69d8cde88968b8902ce1303f70ea4385"
    sha256 cellar: :any_skip_relocation, big_sur:        "60b1ad092cbd57edd8e85ba7a045a21f69d8cde88968b8902ce1303f70ea4385"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68fcdf919ee541f9389adf15f5aa7b107c4e62f6270b2a99cfc6b71ec9287775"
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