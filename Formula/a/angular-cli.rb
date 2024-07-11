require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.1.0.tgz"
  sha256 "5e1b042686fbee72d18f05d26f22cf193d39795a76b831a7b35aadc1b76f32d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a80d0d009db87585d32dd93ae049536286ec16419168435ac821188e591accf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a80d0d009db87585d32dd93ae049536286ec16419168435ac821188e591accf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a80d0d009db87585d32dd93ae049536286ec16419168435ac821188e591accf"
    sha256 cellar: :any_skip_relocation, sonoma:         "968659553b008b365e98cb60cd58cc7b3ba4aba8d79a7acc0684bfd21a127b50"
    sha256 cellar: :any_skip_relocation, ventura:        "968659553b008b365e98cb60cd58cc7b3ba4aba8d79a7acc0684bfd21a127b50"
    sha256 cellar: :any_skip_relocation, monterey:       "968659553b008b365e98cb60cd58cc7b3ba4aba8d79a7acc0684bfd21a127b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4ca3fdffe1676d5d4235e5f8691f6a9d7ba7b5630a81c808b0acd025426b671"
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