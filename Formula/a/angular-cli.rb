class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.1.5.tgz"
  sha256 "03cb7bd806c6e46973e5ae8326774196597d8aed57911ee91495a0151baa3489"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "325420924d7b7f245f785f29e758ede9a4f20bd3854d9ad20edf2574c00af3be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "325420924d7b7f245f785f29e758ede9a4f20bd3854d9ad20edf2574c00af3be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "325420924d7b7f245f785f29e758ede9a4f20bd3854d9ad20edf2574c00af3be"
    sha256 cellar: :any_skip_relocation, sonoma:        "02c104473b7b7d36cdf9f5328209c55dea6169e11c9b1111521c402e6f127b6b"
    sha256 cellar: :any_skip_relocation, ventura:       "02c104473b7b7d36cdf9f5328209c55dea6169e11c9b1111521c402e6f127b6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "325420924d7b7f245f785f29e758ede9a4f20bd3854d9ad20edf2574c00af3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "325420924d7b7f245f785f29e758ede9a4f20bd3854d9ad20edf2574c00af3be"
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