require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.1.1.tgz"
  sha256 "f2c6dc450dbac9a3d84c419b83d7d0a5115bd6866c20768628d5b97693578c40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd71cf6ac3516057584b1de9f63808ab546be26ed705f2a0c3110a78c7458cf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd71cf6ac3516057584b1de9f63808ab546be26ed705f2a0c3110a78c7458cf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd71cf6ac3516057584b1de9f63808ab546be26ed705f2a0c3110a78c7458cf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "133a97c2d8be4fdd3705723691df027ae94690439129a41a039da5d42ec33874"
    sha256 cellar: :any_skip_relocation, ventura:        "133a97c2d8be4fdd3705723691df027ae94690439129a41a039da5d42ec33874"
    sha256 cellar: :any_skip_relocation, monterey:       "133a97c2d8be4fdd3705723691df027ae94690439129a41a039da5d42ec33874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd71cf6ac3516057584b1de9f63808ab546be26ed705f2a0c3110a78c7458cf6"
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