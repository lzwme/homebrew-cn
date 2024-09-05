class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.3.tgz"
  sha256 "aad685c607f60eacd0857a79cf30927e73d02d3dfe03ec4f077afc4bc948b67c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "acf1d459c8dec8f0f37aa1cb5aa1923a6927b3bb3ec369b897ac49ee34751af9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acf1d459c8dec8f0f37aa1cb5aa1923a6927b3bb3ec369b897ac49ee34751af9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acf1d459c8dec8f0f37aa1cb5aa1923a6927b3bb3ec369b897ac49ee34751af9"
    sha256 cellar: :any_skip_relocation, sonoma:         "f12bccd278a93d4ca01033056e12df43e01c4b745b28a9d1c7e83a3cb1b9a9a9"
    sha256 cellar: :any_skip_relocation, ventura:        "f12bccd278a93d4ca01033056e12df43e01c4b745b28a9d1c7e83a3cb1b9a9a9"
    sha256 cellar: :any_skip_relocation, monterey:       "437490e56f386be13f992089ac4969f8f98e59dd312f08cd68085904c7b9779a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acf1d459c8dec8f0f37aa1cb5aa1923a6927b3bb3ec369b897ac49ee34751af9"
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