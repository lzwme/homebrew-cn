class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.0.3.tgz"
  sha256 "9b54039aad793b94f2897d0eed8bcb21269e0ca73cb225d7f85ff083ab364cba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ccf2ce06a2aec8adc08f073ffc25b4aceb939e2b78699f3e25d7fce362b9d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27ccf2ce06a2aec8adc08f073ffc25b4aceb939e2b78699f3e25d7fce362b9d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27ccf2ce06a2aec8adc08f073ffc25b4aceb939e2b78699f3e25d7fce362b9d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "98c14e85240af474146469eae374e22986ddfa87b2c3eb1f422ac1767d5dc28d"
    sha256 cellar: :any_skip_relocation, ventura:       "98c14e85240af474146469eae374e22986ddfa87b2c3eb1f422ac1767d5dc28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27ccf2ce06a2aec8adc08f073ffc25b4aceb939e2b78699f3e25d7fce362b9d3"
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