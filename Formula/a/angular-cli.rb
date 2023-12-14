require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.0.7.tgz"
  sha256 "5dbb806d36c8aa0418193e62583a967a444db9c93b5bf8c3f8121973adff22fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "893c46301eb2ff3f349cbebf7ff830255a5a6ea7a0610757fe756401b44f414b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "893c46301eb2ff3f349cbebf7ff830255a5a6ea7a0610757fe756401b44f414b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "893c46301eb2ff3f349cbebf7ff830255a5a6ea7a0610757fe756401b44f414b"
    sha256 cellar: :any_skip_relocation, sonoma:         "205000a78e5870b3181f08d2906c38576346e4064197e609a5371ee5670930c0"
    sha256 cellar: :any_skip_relocation, ventura:        "205000a78e5870b3181f08d2906c38576346e4064197e609a5371ee5670930c0"
    sha256 cellar: :any_skip_relocation, monterey:       "205000a78e5870b3181f08d2906c38576346e4064197e609a5371ee5670930c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "893c46301eb2ff3f349cbebf7ff830255a5a6ea7a0610757fe756401b44f414b"
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