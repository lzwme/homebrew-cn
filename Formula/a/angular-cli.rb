require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.1.0.tgz"
  sha256 "e312306bded7393f246d49ec4568ab0c44acc56f7d95fad75f9f29d4cc977304"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad116da1dc1d17af39a9de7b1820fedadea1e4adbaa4b4421f68c4c3c154207e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad116da1dc1d17af39a9de7b1820fedadea1e4adbaa4b4421f68c4c3c154207e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad116da1dc1d17af39a9de7b1820fedadea1e4adbaa4b4421f68c4c3c154207e"
    sha256 cellar: :any_skip_relocation, sonoma:         "94540991f1f615693dc2239dd3bfe8c02fc6d9e5d1df3af2e0dcd524315bd3be"
    sha256 cellar: :any_skip_relocation, ventura:        "94540991f1f615693dc2239dd3bfe8c02fc6d9e5d1df3af2e0dcd524315bd3be"
    sha256 cellar: :any_skip_relocation, monterey:       "94540991f1f615693dc2239dd3bfe8c02fc6d9e5d1df3af2e0dcd524315bd3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad116da1dc1d17af39a9de7b1820fedadea1e4adbaa4b4421f68c4c3c154207e"
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