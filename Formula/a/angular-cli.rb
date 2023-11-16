require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.0.1.tgz"
  sha256 "d5ab14d55c65198a5fcc51c0e50392227aa3eea337ba310fb8eac1e1d81af04c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b704ea77d7b0997ccf913e48df072d1e9b7d80e3d2b249162d8f16009b193790"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b704ea77d7b0997ccf913e48df072d1e9b7d80e3d2b249162d8f16009b193790"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b704ea77d7b0997ccf913e48df072d1e9b7d80e3d2b249162d8f16009b193790"
    sha256 cellar: :any_skip_relocation, sonoma:         "748b3a4a9d861375c845b346dc62a62d7f45a4e3d8452f48191ca2353e22e23a"
    sha256 cellar: :any_skip_relocation, ventura:        "748b3a4a9d861375c845b346dc62a62d7f45a4e3d8452f48191ca2353e22e23a"
    sha256 cellar: :any_skip_relocation, monterey:       "748b3a4a9d861375c845b346dc62a62d7f45a4e3d8452f48191ca2353e22e23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b704ea77d7b0997ccf913e48df072d1e9b7d80e3d2b249162d8f16009b193790"
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