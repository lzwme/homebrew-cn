class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.6.tgz"
  sha256 "e4dbe7bb4bbc09b32ca084691a06f5a511db21a06321b2a593bdb70a73c9ccd2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "469f184dbb2e86330ef864050b18ef79804b45cedb688fd4b17ad28ec32d2d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "469f184dbb2e86330ef864050b18ef79804b45cedb688fd4b17ad28ec32d2d85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "469f184dbb2e86330ef864050b18ef79804b45cedb688fd4b17ad28ec32d2d85"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4b9841c6653cfbdcc9fd29ae596644bc0388aab35c94b39a3362d2986a32101"
    sha256 cellar: :any_skip_relocation, ventura:       "a4b9841c6653cfbdcc9fd29ae596644bc0388aab35c94b39a3362d2986a32101"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "469f184dbb2e86330ef864050b18ef79804b45cedb688fd4b17ad28ec32d2d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "469f184dbb2e86330ef864050b18ef79804b45cedb688fd4b17ad28ec32d2d85"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end