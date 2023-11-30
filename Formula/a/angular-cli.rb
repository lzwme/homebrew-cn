require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.0.5.tgz"
  sha256 "f13d0d1e66553e71599be18d17e8056cbb5e83114828f6482f6f281bfd636382"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3c4dc33e33e7be314e9bd0260406b1a38293875d44f2a5e4ded91cfb6bc8c175"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c4dc33e33e7be314e9bd0260406b1a38293875d44f2a5e4ded91cfb6bc8c175"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c4dc33e33e7be314e9bd0260406b1a38293875d44f2a5e4ded91cfb6bc8c175"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc71aea6eec840f5b6c5c10e837bb6a616a1a498005564fd54fee254fae0126e"
    sha256 cellar: :any_skip_relocation, ventura:        "fc71aea6eec840f5b6c5c10e837bb6a616a1a498005564fd54fee254fae0126e"
    sha256 cellar: :any_skip_relocation, monterey:       "fc71aea6eec840f5b6c5c10e837bb6a616a1a498005564fd54fee254fae0126e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c4dc33e33e7be314e9bd0260406b1a38293875d44f2a5e4ded91cfb6bc8c175"
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