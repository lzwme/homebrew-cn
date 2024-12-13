class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.0.5.tgz"
  sha256 "262181c0b637ab9d6b41eff873bcb0df1eadfadbb70897ff488d575f0c4ef3f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c070f3935f6f3af877beb3106ff70ba894157d007a68ff586145ddf6cedd2e85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c070f3935f6f3af877beb3106ff70ba894157d007a68ff586145ddf6cedd2e85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c070f3935f6f3af877beb3106ff70ba894157d007a68ff586145ddf6cedd2e85"
    sha256 cellar: :any_skip_relocation, sonoma:        "f70ad98861920523e06bb2f9d16d2e1f40bf7c9cd8e45390efa8e31d652743aa"
    sha256 cellar: :any_skip_relocation, ventura:       "f70ad98861920523e06bb2f9d16d2e1f40bf7c9cd8e45390efa8e31d652743aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c070f3935f6f3af877beb3106ff70ba894157d007a68ff586145ddf6cedd2e85"
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