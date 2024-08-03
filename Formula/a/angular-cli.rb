class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.1.3.tgz"
  sha256 "f1d99939f2dc07715bc3d58fbadb6ad46e3f870d577ed780ccb536ae7f1459df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73486701b1cf16b2fa396677fc6c05a1c3419100566e84b059b5e1da90b92aa7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73486701b1cf16b2fa396677fc6c05a1c3419100566e84b059b5e1da90b92aa7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73486701b1cf16b2fa396677fc6c05a1c3419100566e84b059b5e1da90b92aa7"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1fd40c3c8001004ba76499af46d294a068c27a8adcff67078eb24b078db6b7a"
    sha256 cellar: :any_skip_relocation, ventura:        "e1fd40c3c8001004ba76499af46d294a068c27a8adcff67078eb24b078db6b7a"
    sha256 cellar: :any_skip_relocation, monterey:       "e1fd40c3c8001004ba76499af46d294a068c27a8adcff67078eb24b078db6b7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c562459b30a51eb6c0e71d7f7c75793b2969a85772b3454f5b13d6de631838f5"
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