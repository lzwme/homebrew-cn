class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.1.0.tgz"
  sha256 "8bf5f8bcff46bb19658ecd1b78418a1a135cbb17ab6f31e3e701ab225a55af5c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68d15b68e9ba43d3bfd30260a6b0f6e68191c224622967dfcfe8f189f0f2f69b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68d15b68e9ba43d3bfd30260a6b0f6e68191c224622967dfcfe8f189f0f2f69b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68d15b68e9ba43d3bfd30260a6b0f6e68191c224622967dfcfe8f189f0f2f69b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1411548ef4c6790792a69df6bf6f24f90cd73ba8984b63a360f5e7720f6afebc"
    sha256 cellar: :any_skip_relocation, ventura:       "1411548ef4c6790792a69df6bf6f24f90cd73ba8984b63a360f5e7720f6afebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68d15b68e9ba43d3bfd30260a6b0f6e68191c224622967dfcfe8f189f0f2f69b"
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