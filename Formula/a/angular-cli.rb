class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.0.6.tgz"
  sha256 "e5196bb939084209d5e93809a80f2ce31c212b44ba0420c833f8aee9dd998624"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eade932aaf439387b96fdee2e820657beb124907893cacfaaa97c0368b4b95ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eade932aaf439387b96fdee2e820657beb124907893cacfaaa97c0368b4b95ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eade932aaf439387b96fdee2e820657beb124907893cacfaaa97c0368b4b95ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f02871dd499750f5b603fa2739be1287cfd3e08ea4987a11abbd4a62dbddd90"
    sha256 cellar: :any_skip_relocation, ventura:       "2f02871dd499750f5b603fa2739be1287cfd3e08ea4987a11abbd4a62dbddd90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eade932aaf439387b96fdee2e820657beb124907893cacfaaa97c0368b4b95ed"
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