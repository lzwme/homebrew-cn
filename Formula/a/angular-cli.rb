require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.1.1.tgz"
  sha256 "f675c691b8c31b792045650b23b9755e3f50c14eff9bb5a0e3570dbf6f6b956b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d66d0e1208b084999443738f5cf7b474be2f4d758dfe3fbacda9910f6238d31"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d66d0e1208b084999443738f5cf7b474be2f4d758dfe3fbacda9910f6238d31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d66d0e1208b084999443738f5cf7b474be2f4d758dfe3fbacda9910f6238d31"
    sha256 cellar: :any_skip_relocation, sonoma:         "cb61c99ebcfab5ec232f544d41bfe2af20907593980fbc5eeb1b75c673820377"
    sha256 cellar: :any_skip_relocation, ventura:        "cb61c99ebcfab5ec232f544d41bfe2af20907593980fbc5eeb1b75c673820377"
    sha256 cellar: :any_skip_relocation, monterey:       "cb61c99ebcfab5ec232f544d41bfe2af20907593980fbc5eeb1b75c673820377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e225b93098490a7915d77a5b698fbbc643a22f42d068318b71aae5236376594"
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