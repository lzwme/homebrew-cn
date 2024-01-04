require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.0.9.tgz"
  sha256 "27d5f0649b1949f5175f5408de65fcc56f47895c6ae0e0d17b9f14257f10bc4c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26987b60d6ed14bdc80c9d29af17fd67d938c29daf83219ace06d9935f169359"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "26987b60d6ed14bdc80c9d29af17fd67d938c29daf83219ace06d9935f169359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26987b60d6ed14bdc80c9d29af17fd67d938c29daf83219ace06d9935f169359"
    sha256 cellar: :any_skip_relocation, sonoma:         "723e8db0691fb8b0f35cd0a8659b19159869d33acc2d5ab8039318b4ba5d7de7"
    sha256 cellar: :any_skip_relocation, ventura:        "723e8db0691fb8b0f35cd0a8659b19159869d33acc2d5ab8039318b4ba5d7de7"
    sha256 cellar: :any_skip_relocation, monterey:       "723e8db0691fb8b0f35cd0a8659b19159869d33acc2d5ab8039318b4ba5d7de7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26987b60d6ed14bdc80c9d29af17fd67d938c29daf83219ace06d9935f169359"
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