class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.1.tgz"
  sha256 "1afa34b38a1ab99c462db834a83103b95302fd004cfc631b189877b462a4fb89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98a0d0683d85a99cd10149e8f752b78c8cbaac1657fc7605e1bfc2b6fa630509"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98a0d0683d85a99cd10149e8f752b78c8cbaac1657fc7605e1bfc2b6fa630509"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98a0d0683d85a99cd10149e8f752b78c8cbaac1657fc7605e1bfc2b6fa630509"
    sha256 cellar: :any_skip_relocation, sonoma:         "608fac3fc4ff05f38c32603af427cf0f577302d77c986623a38acde107e2f50a"
    sha256 cellar: :any_skip_relocation, ventura:        "608fac3fc4ff05f38c32603af427cf0f577302d77c986623a38acde107e2f50a"
    sha256 cellar: :any_skip_relocation, monterey:       "608fac3fc4ff05f38c32603af427cf0f577302d77c986623a38acde107e2f50a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98a0d0683d85a99cd10149e8f752b78c8cbaac1657fc7605e1bfc2b6fa630509"
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