class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.2.tgz"
  sha256 "af59c0ce50025c963b55a5ea131eac862eee05f6817aef1ec026e1448fdfd6b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34dbb828b24c83bf0f820435b57adcba0642daf22786dd71a734f3474c0e05ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34dbb828b24c83bf0f820435b57adcba0642daf22786dd71a734f3474c0e05ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34dbb828b24c83bf0f820435b57adcba0642daf22786dd71a734f3474c0e05ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "851a957ee2dda435058d023e738cc8f3f21a5ba3c393371592ed8711588c39dc"
    sha256 cellar: :any_skip_relocation, ventura:       "851a957ee2dda435058d023e738cc8f3f21a5ba3c393371592ed8711588c39dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34dbb828b24c83bf0f820435b57adcba0642daf22786dd71a734f3474c0e05ef"
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