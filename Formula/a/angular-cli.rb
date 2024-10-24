class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.10.tgz"
  sha256 "d48b8c6a2bbf731d7b97eb9539ef8defe993e141ec7c3ba15b8d404aac936820"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81e87dcf939435860747fd9e6209bb3324441a0e3be8fa8696cfed3caaff0f05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81e87dcf939435860747fd9e6209bb3324441a0e3be8fa8696cfed3caaff0f05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81e87dcf939435860747fd9e6209bb3324441a0e3be8fa8696cfed3caaff0f05"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ac1b7066a517536e0d4e837b6987e085657792bf67278ca3e44addf8a35d840"
    sha256 cellar: :any_skip_relocation, ventura:       "4ac1b7066a517536e0d4e837b6987e085657792bf67278ca3e44addf8a35d840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81e87dcf939435860747fd9e6209bb3324441a0e3be8fa8696cfed3caaff0f05"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end